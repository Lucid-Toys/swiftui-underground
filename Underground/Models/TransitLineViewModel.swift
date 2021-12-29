//
//  APIData.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import Foundation
import Network
import SwiftUI

typealias CompletionHandler = (_ success: Bool) -> Void

enum DataState {
  case loading, loaded, offline, stale, spotty
}

enum TfLMode: String {
  case tube = "tube"
  case DLR = "dlr"
  case overground = "overground"
  case tfLRail = "tflrail"
}

struct TfLDisruption: Decodable, Identifiable, Equatable {
  // swiftlint:disable identifier_name
  public var id: String { "\(lineId ?? "status")-\(created)" }
  public var lineId: String?
  public var statusSeverity: Int
  public var statusSeverityDescription: String
  public var reason: String?
  public var created: String

  enum CodingKeys: String, CodingKey {
    case lineId
    case statusSeverity
    case statusSeverityDescription
    case reason
    case created
  }
}

enum TfLLineID: String, Decodable {
  case bakerloo = "bakerloo"
  case central = "central"
  case circle = "circle"
  case district = "district"
  case DLR = "dlr"
  case hammersmithCity = "hammersmith-city"
  case jubilee = "jubilee"
  case metropolitan = "metropolitan"
  case northen = "northern"
  case overground = "london-overground"
  case piccadilly = "piccadilly"
  case tfLRail = "tfl-rail"
  case victoria = "victoria"
  case waterlooCity = "waterloo-city"
}

struct TfLLineColor {
  static var color: [TfLLineID: Color] = [
    TfLLineID.bakerloo: Color(red: 0.54, green: 0.31, blue: 0.14),
    TfLLineID.central: Color(red: 0.87, green: 0.15, blue: 0.12),
    TfLLineID.circle: Color(red: 0.89, green: 0.71, blue: 0.00),
    TfLLineID.district: Color(red: 0.00, green: 0.45, blue: 0.16),
    TfLLineID.DLR: Color(red: 0.00, green: 0.69, blue: 0.68),
    TfLLineID.hammersmithCity: Color(red: 0.84, green: 0.60, blue: 0.69),
    TfLLineID.jubilee: Color(red: 0.42, green: 0.45, blue: 0.47),
    TfLLineID.metropolitan: Color(red: 0.46, green: 0.06, blue: 0.34),
    TfLLineID.northen: Color(red: 0.10, green: 0.10, blue: 0.10),
    TfLLineID.overground: Color(red: 0.91, green: 0.42, blue: 0.06),
    TfLLineID.piccadilly: Color(red: 0.10, green: 0.2, blue: 0.8),
    TfLLineID.tfLRail: Color(red: 0.00, green: 0.10, blue: 0.66),
    TfLLineID.victoria: Color(red: 0.02, green: 0.63, blue: 0.89),
    TfLLineID.waterlooCity: Color(red: 0.47, green: 0.82, blue: 0.74)
  ]
  
  static subscript (key: TfLLineID) -> Color {
    // swiftlint:disable implicit_getter
    get {
      if let newValue = color[key] {
        return newValue
      } else {
        return Color(red: 0.00, green: 0.00, blue: 0.00)
      }
    }
  }
}

struct TransitLine: Decodable, Identifiable, Equatable {
  static func == (lhs: TransitLine, rhs: TransitLine) -> Bool {
    lhs.id == rhs.id && lhs.lineStatuses.elementsEqual(rhs.lineStatuses)
  }
  
  var id: TfLLineID
  var name: String
  var lineStatuses: [TfLDisruption]
  var color: Color {
    TfLLineColor[id]
  }

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case lineStatuses
  }
}

typealias TransitLineIDs = [String]

extension TransitLineIDs: RawRepresentable {
  public init?(rawValue: String) {
    guard let data = rawValue.data(using: .utf8),
          let result = try? JSONDecoder().decode(TransitLineIDs.self, from: data) else {
      return nil
    }
    
    self = result
  }
  
  public var rawValue: String {
    guard let data = try? JSONEncoder().encode(self),
          let result = String(data: data, encoding: .utf8) else {
      return "[]"
    }
    
    return result
  }
}

public class TransitLineViewModel: ObservableObject {
  static var shared = TransitLineViewModel()
  
  @AppStorage("favouriteLineIDs") var favouriteLineIDs: TransitLineIDs = favourites.get() {
    didSet {
      self.objectWillChange.send()
    }
  }
  
  @Published var lines = [TransitLine]()
  @Published var dataState: DataState = .stale
  @Published var lastUpdated: Date = Date()
  
  var favouriteLines: [TransitLine] {
    lines.filter { favouriteLineIDs.contains($0.id.rawValue) }
  }
  
  var nonFavouriteLines: [TransitLine] {
    lines.filter { !favouriteLineIDs.contains($0.id.rawValue) }
  }
  
  private var timer: Timer?
  let networkMonitor = NWPathMonitor()

  init() {
    // Schedule the fetch to happen every 5 seconds
    timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
      self.load()
    }

    // Kick off an initial load
    load()

    // Let's handle network connection availability
    networkMonitor.pathUpdateHandler = { path in
      if path.status == .satisfied {
        // If the network is available, mark data as stale.
        // This will soon be changed by the load() function.
        DispatchQueue.main.async {
          self.dataState = .stale
          print("Network connection detected")
        }
      } else {
        // Otherwise, let the user know that no updates are happening since there's no internet connection.
        DispatchQueue.main.async {
          self.dataState = .offline
          print("No network connection")
        }
      }
    }

    // Set up the network monitor
    let queue = DispatchQueue(label: "Monitor")
    networkMonitor.start(queue: queue)
  }

  // MARK: Loading function
  func load(_ completionHandler: CompletionHandler? = nil) {
    // Start the loading process.
    // If the lines array is empty, let's initialise things with a loading status.
    if self.lines.isEmpty {
      self.dataState = .loading
    }

    let url = URL(string: "https://underground.lucid.toys/api/data")!
    
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadRevalidatingCacheData
    
    let session = URLSession(configuration: config)

    session.dataTask(with: url) {(data, _, error) in
      do {
        DispatchQueue.main.sync {
          // If 6 seconds or more have passed since the last successful update, let the user know
          let dateComponents = Calendar.current.dateComponents([.second], from: self.lastUpdated, to: Date())
          if dateComponents.second! >= 6 {
            self.dataState = .loading
          }

          if dateComponents.second! >= 12 {
            self.dataState = .spotty
          }
        }

        if let response = data {
          let decodedResponse = try JSONDecoder().decode([TransitLine].self, from: response)
          DispatchQueue.main.sync {
            // Update/set the lines array
            if !self.lines.elementsEqual(decodedResponse) {
              withAnimation { self.lines = decodedResponse }
            }

            // Let the user know everything has loaded
            self.dataState = .loaded

            // Update the timestamp
            self.lastUpdated = Date()
          }
        } else {
          print("No data received from Lucid Underground API.")
        }

        // load() has an optional completion block. We'll run that here with `success: true`
        if completionHandler != nil {
          completionHandler!(true)
        }
      } catch {
        print(error)
        print("Error fetching line statuses")

        // Run the completion block with `success: false`
        if completionHandler != nil {
          completionHandler!(false)
        }
      }
    }.resume()
  }
  
  func toggleFavourite(lineId: String) {
    withAnimation {
      if let index = favouriteLineIDs.firstIndex(of: lineId) {
        favouriteLineIDs.remove(at: index)
      } else {
        favouriteLineIDs.append(lineId)
      }
    }
  }
  
  func isFavourite(lineId: String) -> Bool {
    return favouriteLineIDs.contains(lineId)
  }
}
