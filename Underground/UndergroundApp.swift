//
//  UndergroundApp.swift
//  Underground
//
//  Created by Daniel Eden on 29/12/2021.
//  Copyright © 2021 Daniel Eden. All rights reserved.
//

import Foundation
import SwiftUI

@main
struct UndergroundApp: App {
  #if os(iOS)
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  #endif
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
