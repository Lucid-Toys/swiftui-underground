//
//  ContentView.swift
//  WatchUnderground Extension
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TransitLineStatusList()
          .environmentObject(TransitLineViewModel.shared)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
