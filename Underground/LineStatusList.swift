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
    ScrollView {
      VStack {
        UpdatingLiveIndicator(status: data.dataState, lastUpdated: data.lastUpdated)
        
        ForEach(data.lines) { line in
          #if os(watchOS)
          LineStatusListRow(line: line, isFavourite: favourites.get().contains(line.id.rawValue))
          #else
          LineStatusListRow(line: line, isFavourite: favourites.get().contains(line.id.rawValue))
            .shadow(radius: 6)
            .padding(.horizontal, 8)
          #endif
        }
      }
      .padding(.bottom, 8)
      .background(Color("PrimaryBackground"))
      .navigationBarTitle("Underground Status")
    }
  }
}
