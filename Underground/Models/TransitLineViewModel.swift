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

struct TfLDisruption: Codable, Identifiable, Hashable {
  public var id: Int
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
  case elizabethLine = "elizabeth"
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
    .waterlooCity: Color(red: 0.47, green: 0.82, blue: 0.74),
    .elizabethLine: Color(red: 0.41, green: 0.31, blue: 0.63)
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

struct TransitLine: Codable, Identifiable, Hashable {
  enum DisruptionSeverity {
    case high, medium, low
  }
  
  var id: TfLLineID
  var name: String
  var lineStatuses: [TfLDisruption]
  var color: Color {
    TfLLineColor[id]
  }
  
  var mostSevereStatus: TfLDisruption? {
    lineStatuses.reduce(TfLDisruption?.none) { currentMostSevere, currentDisruption in
      guard let currentMostSevere = currentMostSevere else {
        return currentDisruption
      }
      
      return currentDisruption.statusSeverity < currentMostSevere.statusSeverity
      ? currentDisruption
      : currentMostSevere
    }
  }
  
  var mostSevereDisruptionSeverity: DisruptionSeverity {
    guard let status = mostSevereStatus else {
      return .low
    }
    
    switch status.statusSeverity {
    case let x where x < 6:
      return .high
    case let x where (x < 10 || x == 20):
      return .medium
    default:
      return .low
    }
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
  typealias Resource = [TransitLine]
  
  static let API_URL = URL(string: "https://underground.lucid.toys/api/data")!
  private let urlWatcher = URLWatcher(url: TransitLineViewModel.API_URL, delay: 5)
  
  @AppStorage("favouriteLineIDs") var favouriteLineIDs: TransitLineIDs = [] {
    didSet {
      self.objectWillChange.send()
    }
  }
  
  @AppStorage("lastUpdated") var storeLastUpdated: TimeInterval = Date().timeIntervalSince1970
  
  @Published var state: LoadingState<Resource> = .idle
  
  var lastUpdated: Date {
    Date(timeIntervalSince1970: storeLastUpdated)
  }
  
  init() {
    if let cachedResults = UserDefaults.standard.data(forKey: "cachedResults"),
       let decodedResults = try? JSONDecoder().decode(Resource.self, from: cachedResults) {
      state = .loaded(data: decodedResults)
    }
  }
  
  var lines: Resource {
    if case .loaded(let lines) = state {
      return lines
    } else {
      return []
    }
  }
  
  var favouriteLines: Resource {
    lines.filter { favouriteLineIDs.contains($0.id.rawValue) }
  }
  
  var nonFavouriteLines: Resource {
    lines.filter { !favouriteLineIDs.contains($0.id.rawValue) }
  }

  // MARK: Loading function
  func load() async {
    // Start the loading process.
    // If the lines array is empty, let's initialise things with a loading status.
    if self.lines.isEmpty {
      self.state = .loading
    }
    
    do {
      for try await data in urlWatcher {
        let newData = try JSONDecoder().decode(Resource.self, from: data)
        
        withAnimation {
          state = .loaded(data: newData)
        }
        
        UserDefaults.standard.set(data, forKey: "cachedResults")
        storeLastUpdated = Date().timeIntervalSince1970
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func toggleFavourite(lineId: TfLLineID) {
    withAnimation {
      if let index = favouriteLineIDs.firstIndex(of: lineId.rawValue) {
        favouriteLineIDs.remove(at: index)
      } else {
        favouriteLineIDs.append(lineId.rawValue)
      }
    }
  }
  
  func isFavourite(lineId: TfLLineID) -> Bool {
    return favouriteLineIDs.contains(lineId.rawValue)
  }
}
