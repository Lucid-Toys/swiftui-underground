//
//  SyncModel.swift
//  Underground
//
//  Created by Daniel Eden on 24/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import Foundation

class SyncModel: ObservableObject {
    let key = "syncUndergroundFavourites"
    @Published var value: [String] = []
  
    init() {

    }

    func get() -> [String] {
        #if !os(watchOS)
        objectWillChange.send()
        let val: [String] = NSUbiquitousKeyValueStore.default.array(forKey: key) as? [String] ?? [String]()
        self.value = val
        return val
        #else
        return [String]()
        #endif
    }

    func set(_ data: [String]) {
        #if !os(watchOS)
        objectWillChange.send()
        NSUbiquitousKeyValueStore.default.set(data, forKey: key)
        self.value = data
        #endif
    }
}
