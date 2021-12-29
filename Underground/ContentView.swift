//
//  ContentView.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = TransitLineViewModel()
  
  var body: some View {
    NavigationView {
      TransitLineStatusList()
        .navigationBarTitle("Underground Status")
        .environmentObject(viewModel)
        .task {
          await viewModel.load()
        }
        #if !targetEnvironment(macCatalyst)
        .refreshable {
          await viewModel.load()
        }
        #endif
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
