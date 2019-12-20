//
//  APIData.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import Foundation

enum TfLMode: String {
    case Tube = "tube"
    case DLR = "dlr"
    case Overground = "overground"
    case TfLRail = "tflrail"
}

struct TfLDisruption: Decodable, Identifiable {
    public var id: Int
    public var lineId: String?
    public var statusSeverity: Int
    public var statusSeverityDescription: String
    public var reason: String?
    public var created: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case lineId = "lineId"
        case statusSeverity = "statusSeverity"
        case statusSeverityDescription = "statusSeverityDescription"
        case reason = "reason"
        case created = "created"
    }
}

struct APIResponse: Decodable, Identifiable {
    public var id: TfLLineID
    public var name: String
    public var lineStatuses: [TfLDisruption]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case lineStatuses = "lineStatuses"
    }
}

public class DataFetcher: ObservableObject {
    @Published var lines = [APIResponse]()
    private var timer: Timer? = nil
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            self.load()
        }
        load()
    }
    
    func load() {
        let url = URL(string: "https://underground.lucid.toys/api/data")!
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: url) {(data, response, error) in
            do {
                print("Fetching underground status data")
                let favourites = UserDefaults.standard.object(forKey: "syncFavourites") as? [String] ?? [String]()
                if let d = data {
                    let decodedResponse = try JSONDecoder().decode([APIResponse].self, from: d)
                    DispatchQueue.main.async {
                        let lines = decodedResponse.sorted {
                            return favourites.firstIndex(of: $0.id.rawValue) ?? Int.max < favourites.firstIndex(of: $1.id.rawValue) ?? Int.max
                        }
                        self.lines = lines
                    }
                } else {
                    print("No data")
                }
            } catch {
                print(error)
                print("Error fetching line statuses")
            }
        }.resume()
    }
}
