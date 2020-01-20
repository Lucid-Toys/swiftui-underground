//
//  LineStatusList.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

let favourites = SyncModel()

struct LineStatusList: View {
    @ObservedObject var data: UndergroundDataFetcher
    
    var body: some View {
        List {
            UpdatingLiveIndicator(status: data.dataState, lastUpdated: data.lastUpdated)
            ForEach(data.lines) { line in
              LineStatusListRow(line: line, isFavourite: favourites.get().contains(line.id.rawValue))
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
            .animation(.default)
        }
        .navigationBarTitle("Underground Status")
    }
}

struct UpdatingLiveIndicator: View {
    @State var opacity = 1.0
    var status: DataState
    var lastUpdated: Date
    let formatter = DateFormatter()
    
    init(status: DataState, lastUpdated: Date) {
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        self.status = status
        self.lastUpdated = lastUpdated
    }
    
    var body: some View {
        HStack {
            if (status != .Offline) {
                HStack {
                    Image(systemName: "wifi")
                        .opacity(self.opacity)
                        .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                        .onAppear() {
                            self.opacity = 0.3
                        }
                    Text("Updating Live")
                }
                .foregroundColor(.secondary)
            } else {
                HStack(alignment: .top) {
                    Image(systemName: "wifi.slash")
                    VStack(alignment: .leading) {
                        Text("Currently offline")
                            .fontWeight(.bold)
                        #if !os(watchOS)
                        Text("Last updated at \(formatter.string(from: self.lastUpdated))")
                        #endif
                    }
                }
                .foregroundColor(Color("Red"))
            }
        }
        .animation(.default)
        .font(.caption)
    }
}


