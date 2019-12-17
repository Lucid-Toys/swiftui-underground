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
        TabView {
            NavigationView {
                LineStatusList()
                    .navigationBarTitle("Underground Status")
            }
            .tabItem {
                Image(systemName: "tram.fill")
                Text("Status")
            }
            
            AboutView()
                .tabItem {
                    Image(systemName: "questionmark.circle.fill")
                    Text("About")
            }
        }
    }
}

struct AboutView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Image("GlossyAppIcon")
                    .resizable()
                    .frame(width: 128, height: 128, alignment: .center)
                Text("Lucid Underground")
                    .font(.headline)
                Text("An app built by Daniel Eden, using open data from Transport for London.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .navigationBarTitle(Text("About Lucid Underground"), displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
