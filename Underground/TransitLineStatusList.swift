//
//  LineStatusList.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

struct TransitLineStatusList: View {
  @EnvironmentObject var linesViewModel: TransitLineViewModel

  var body: some View {
    List {
      if !linesViewModel.favouriteLines.isEmpty {
        Section(header: Label("Favourited Lines", systemImage: "star")) {
          ForEach(linesViewModel.favouriteLines) { line in
            TransitLineStatusListRow(line: line)
              .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button(action: { linesViewModel.toggleFavourite(lineId: line.id) }) {
                  Label("Unfavourite", systemImage: "star.slash")
                }
              }
          }
        }
      }
      
      Section(header: Label("TfL Lines", systemImage: "tram")) {
        ForEach(linesViewModel.nonFavouriteLines) { line in
          TransitLineStatusListRow(line: line)
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
              Button(action: { linesViewModel.toggleFavourite(lineId: line.id) }) {
                Label("Favourite", systemImage: "star")
              }
              .tint(.yellow)
            }
        }
      }
    }
    .navigationBarTitle("Underground Status")
    .toolbar {
      #if !os(watchOS)
      ToolbarItem(placement: .status) {
        UpdatingLiveIndicator(status: linesViewModel.state, lastUpdated: linesViewModel.lastUpdated)
      }
      #endif
    }
  }
}
