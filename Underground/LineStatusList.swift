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
        #if !os(watchOS)
        UpdatingLiveIndicator(status: data.dataState, lastUpdated: data.lastUpdated)
        #endif

        ForEach(data.lines) { line in
          LineStatusListRow(line: line, isFavourite: favourites.get().contains(line.id.rawValue))
            .listRowInsets(EdgeInsets())
            .animation(nil)
        }
      }
      .animation(.default)
      .navigationBarTitle("Underground Status")
    }
}
