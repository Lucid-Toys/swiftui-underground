//
//  URLWatcher.swift
//  Underground
//
//  Created by Daniel Eden on 31/12/2021.
//  Copyright © 2021 Daniel Eden. All rights reserved.
//

import Foundation

struct URLWatcher: AsyncSequence, AsyncIteratorProtocol {
  typealias Element = Data
  
  let url: URL
  let delay: Int
  private var comparisonData: Data?
  private var isActive = true
  
  init(url: URL, delay: Int = 10) {
    self.url = url
    self.delay = delay
  }
  
  mutating func next() async throws -> Element? {
    // Once we're inactive always return nil immediately
    guard isActive else { return nil }
    
    if comparisonData == nil {
      // If this is our first iteration, return the initial value
      comparisonData = try await fetchData()
    } else {
      // Otherwise, sleep for a while and see if our data changed
      while true {
        try await Task.sleep(nanoseconds: UInt64(delay) * 1_000_000_000)
        
        let latestData = try await fetchData()
        
        if latestData != comparisonData {
          // New data is different from previous data,
          // so update previous data and send it back
          comparisonData = latestData
          break
        }
      }
    }
    
    if comparisonData == nil {
      isActive = false
      return nil
    } else {
      return comparisonData
    }
  }
  
  private func fetchData() async throws -> Element {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
  }
  
  func makeAsyncIterator() -> URLWatcher {
    self
  }
}
