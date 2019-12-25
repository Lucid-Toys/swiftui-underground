//
//  SyncModel.swift
//  Underground
//
//  Created by Daniel Eden on 24/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import Foundation

class SyncModel {
  let key = "syncUndergroundFavourites"
  
  init() {
    
  }
  
  func get() -> [String] {
    #if !os(watchOS)
    let val: [String] = NSUbiquitousKeyValueStore.default.array(forKey: key) as? [String] ?? [String]()
    return val
    #else
    return [String]()
    #endif
  }
  
  func set(_ data: [String]) {
    #if !os(watchOS)
    NSUbiquitousKeyValueStore.default.set(data, forKey: key)
    #endif
  }
}
