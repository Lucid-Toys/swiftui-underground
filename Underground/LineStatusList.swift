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
        .listRowInsets(EdgeInsets())
      
      ForEach(data.lines) { line in
        LineStatusListRow(line: line, isFavourite: favourites.get().contains(line.id.rawValue))
      }
      .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
      .animation(.default)
    }
    .navigationBarTitle("Underground Status")
    // The minimum list row height is set so that UpdatingLiveIndicator
    // doesn't render strangely
    .environment(\.defaultMinListRowHeight, 10)
  }
}
