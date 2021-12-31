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
