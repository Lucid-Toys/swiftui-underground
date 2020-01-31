//
//  ContentView.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI  

struct ContentView: View {
  @EnvironmentObject var data: UndergroundDataFetcher
  @EnvironmentObject var device: DeviceModel
  
  var body: some View {
    TabView {
      NavigationView {
        LineStatusList(data: data)
          .navigationBarTitle("Underground Status", displayMode: .inline)
      }
      .navigationViewStyle(StackNavigationViewStyle())
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
    .background(Color("SecondaryBackground"))
    .edgesIgnoringSafeArea(.top)
  }
}

struct AboutView: View {
  var body: some View {
    VStack(spacing: 8) {
      Image("GlossyAppIcon")
        .resizable()
        .frame(width: 128, height: 128, alignment: .center)
        .shadow(radius: 12)
      Text("Lucid Underground")
        .font(.headline)
      Text("An app built by Daniel Eden, using open data from Transport for London.")
        .font(.subheadline)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
