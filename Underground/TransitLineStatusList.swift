//
//  LineStatusList.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

struct TransitListSection: Hashable {
  var title: String
  var lines: [TransitLine]
}

struct TransitLineStatusList: View {
  @EnvironmentObject var linesViewModel: TransitLineViewModel
  
  var sections: [TransitListSection] {
    [
      TransitListSection(title: "Favourite Lines", lines: linesViewModel.favouriteLines),
      TransitListSection(title: "TfL Lines", lines: linesViewModel.nonFavouriteLines)
    ]
  }
  
  var body: some View {
    List {
      if linesViewModel.lastUpdated.timeIntervalSinceNow > (60 * 60) {
        VStack(alignment: .leading) {
          Text("\(Image(systemName: "wifi.slash")) This data may be out of date")
            .fontWeight(.bold)
          Text("Last updated: \(linesViewModel.lastUpdated, style: .relative)")
            .foregroundStyle(.secondary)
        }
        .foregroundStyle(.black)
        .listRowBackground(Color.yellow)
        .font(.footnote)
      }
      
      ForEach(sections, id: \.title) { section in
        if !section.lines.isEmpty {
          Section(section.title) {
            ForEach(section.lines) { line in
              TransitLineStatusListRow(line: line)
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                  Button(action: { linesViewModel.toggleFavourite(lineId: line.id) }) {
                    Label(
                      linesViewModel.isFavourite(lineId: line.id) ? "Unfavourite" : "Favourite",
                      systemImage: "star")
                  }
                  .symbolVariant(linesViewModel.isFavourite(lineId: line.id) ? .slash : .fill)
                  .tint(linesViewModel.isFavourite(lineId: line.id) ? .none : .yellow)
                }
                .id(line.id)
            }
          }
        }
      }
    }
    .transition(.slide)
    .navigationBarTitle("Underground Status")
    #if targetEnvironment(macCatalyst)
    .toolbar {
      Button(action: { Task { await linesViewModel.load() } }) {
        Label("Refresh", systemImage: "arrow.triangle.2.circlepath")
      }
    }
    #endif
  }
  
}
