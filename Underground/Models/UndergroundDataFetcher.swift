//
//  APIData.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import Foundation
import Network

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

struct TfLDisruption: Decodable, Identifiable {
  // swiftlint:disable identifier_name
  public var id = UUID()
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

struct APIResponse: Decodable, Identifiable {
  public var id: TfLLineID
  public var name: String
  public var lineStatuses: [TfLDisruption]

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case lineStatuses
  }
}

public class UndergroundDataFetcher: ObservableObject {
  let config = URLSessionConfiguration.default
  let urlSession: URLSession
  let favouritesModel = SyncModel()
  @Published var lines = [APIResponse]()
  @Published var dataState: DataState = .stale
  @Published var lastUpdated: Date = Date()
  private var timer: Timer?
  let networkMonitor = NWPathMonitor()

  init() {
    // Only try to fetch data if there's a network connection
    config.waitsForConnectivity = true
    urlSession = URLSession(configuration: config)

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

    urlSession.dataTask(with: url) {(data, _, error) in
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

        // Fetch the array of favourited lines
        let favourites = self.favouritesModel.get()

        #if DEBUG
        print("State is \(self.dataState)")
        print("Fetching underground status data...")
        print("Favourites: \(favourites)")
        #endif

        if let response = data {
          let decodedResponse = try JSONDecoder().decode([APIResponse].self, from: response)
          DispatchQueue.main.sync {
            // Update/set the lines array
            let lines = decodedResponse.sorted {
              return favourites.firstIndex(of: $0.id.rawValue) ?? Int.max < favourites.firstIndex(of: $1.id.rawValue) ?? Int.max
            }
            self.lines = lines

            // Let the user know everything has loaded
            self.dataState = .loaded

            // Update the timestamp
            self.lastUpdated = Date()
            print("State is \(self.dataState)")
            print("Updated at \(self.lastUpdated)\n")
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
}
