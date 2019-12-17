//
//  ContentView.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI  

struct ContentView: View {
    var body: some View {
        NavigationView {
            LineStatusList()
                .navigationBarTitle(
                    Text("Underground Status"),
                    displayMode: .inline
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
