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

struct TfLDisruption: Codable, Identifiable, Equatable {
  public var id: String { "\(lineId ?? "status")-\(created)" }
  public var lineId: String?
  public var statusSeverity: Int
  public var statusSeverityDescription: String
  public var reason: String?
  public var created: String
}

enum TfLLineID: String, Codable {
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
    .bakerloo: Color(red: 0.54, green: 0.31, blue: 0.14),
    .central: Color(red: 0.87, green: 0.15, blue: 0.12),
    .circle: Color(red: 0.89, green: 0.71, blue: 0.00),
    .district: Color(red: 0.00, green: 0.45, blue: 0.16),
    .DLR: Color(red: 0.00, green: 0.69, blue: 0.68),
    .hammersmithCity: Color(red: 0.84, green: 0.60, blue: 0.69),
    .jubilee: Color(red: 0.42, green: 0.45, blue: 0.47),
    .metropolitan: Color(red: 0.46, green: 0.06, blue: 0.34),
    .northen: Color(red: 0.10, green: 0.10, blue: 0.10),
    .overground: Color(red: 0.91, green: 0.42, blue: 0.06),
    .piccadilly: Color(red: 0.10, green: 0.2, blue: 0.8),
    .tfLRail: Color(red: 0.00, green: 0.10, blue: 0.66),
    .victoria: Color(red: 0.02, green: 0.63, blue: 0.89),
    .waterlooCity: Color(red: 0.47, green: 0.82, blue: 0.74)
  ]
  
  static subscript (key: TfLLineID) -> Color {
    get {
      if let newValue = color[key] {
        return newValue
      } else {
        return Color(red: 0.00, green: 0.00, blue: 0.00)
      }
    }
  }
}

struct TransitLine: Codable, Identifiable, Equatable {
  static func == (lhs: TransitLine, rhs: TransitLine) -> Bool {
    lhs.id == rhs.id && lhs.lineStatuses.elementsEqual(rhs.lineStatuses)
  }
  
  var id: TfLLineID
  var name: String
  var lineStatuses: [TfLDisruption]
  var color: Color {
    TfLLineColor[id]
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

enum LoadingState<Resource: Codable> {
  case idle, loading, offline
  case loaded(data: Resource)
}

@MainActor
public class TransitLineViewModel: ObservableObject {
  static let API_URL = URL(string: "https://underground.lucid.toys/api/data")!
  
  @AppStorage("favouriteLineIDs") var favouriteLineIDs: TransitLineIDs = favourites.get() {
    didSet {
      self.objectWillChange.send()
    }
  }
  
  @Published var state: LoadingState<[TransitLine]> = .idle
  @Published var lastUpdated: Date = Date()
  
  var lines: [TransitLine] {
    if case .loaded(let lines) = state {
      return lines
    } else {
      return []
    }
  }
  
  var favouriteLines: [TransitLine] {
    lines.filter { favouriteLineIDs.contains($0.id.rawValue) }
  }
  
  var nonFavouriteLines: [TransitLine] {
    lines.filter { !favouriteLineIDs.contains($0.id.rawValue) }
  }

  // MARK: Loading function
  func load() async {
    // Start the loading process.
    // If the lines array is empty, let's initialise things with a loading status.
    if self.lines.isEmpty {
      self.state = .loading
    }
    
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadRevalidatingCacheData
    
    let session = URLSession(configuration: config)
    
    do {
      let (data, _) = try await session.data(from: Self.API_URL)
      
      let newData = try JSONDecoder().decode([TransitLine].self, from: data)
      
      state = .loaded(data: newData)
    } catch {
      print(error.localizedDescription)
      self.state = .idle
    }
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
