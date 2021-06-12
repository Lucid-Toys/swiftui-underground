//
//  LineStatusList.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

let favourites = SyncModel()

struct TransitLineStatusList: View {
  @EnvironmentObject var linesViewModel: TransitLineViewModel

  var body: some View {
    List {
      #if !os(watchOS)
      UpdatingLiveIndicator(status: linesViewModel.dataState, lastUpdated: linesViewModel.lastUpdated)
      #endif
      
      Section(header: Label("Favourited Lines", systemImage: "star")) {
        ForEach(linesViewModel.favouriteLines) { line in
          TransitLineStatusListRow(line: line)
            .contextMenu {
              Button(action: { linesViewModel.toggleFavourite(lineId: line.id.rawValue) }) {
                Label("Unavourite", systemImage: "star.fill")
              }
            }
        }
      }
      
      Section(header: Label("TfL Lines", systemImage: "tram")) {
        ForEach(linesViewModel.nonFavouriteLines) { line in
          TransitLineStatusListRow(line: line)
            .contextMenu {
              Button(action: { linesViewModel.toggleFavourite(lineId: line.id.rawValue) }) {
                Label("Favourite", systemImage: "star")
              }
            }
        }
      }
    }
    .navigationBarTitle("Underground Status")
  }
}
