//
//  ListStatusDetail.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

// swiftlint:disable multiple_closures_with_trailing_closure

import SwiftUI

func shouldShowPoorServiceView(_ lineStatuses: [TfLDisruption]) -> Bool {
  if lineStatuses.count > 1 || (lineStatuses.count >= 1 && lineStatuses[0].statusSeverity != 10) {
    return true
  } else {
    return false
  }
}

struct TransitLineDetailView: View {
  @EnvironmentObject var lineViewModel: TransitLineViewModel
  
  var line: TransitLine
  
  var isFavourite: Bool {
    lineViewModel.favouriteLineIDs.contains(line.id.rawValue)
  }
  
  var isInPoorService: Bool {
    if line.lineStatuses.count > 1 || (line.lineStatuses.count >= 1 && line.lineStatuses[0].statusSeverity != 10) {
      return true
    } else {
      return false
    }
  }
  
  var body: some View {
    Form {
      Section(header: Text("Line Status")) {
        if isInPoorService {
          ForEach(self.line.lineStatuses) { status in
            PoorServiceView(status: status)
          }
        } else {
          GoodServiceView()
        }
      }
      
      Button(action: {
        lineViewModel.toggleFavourite(lineId: line.id)
      }) {
        Label(isFavourite ? "Unfavourite" : "Favourite", systemImage: isFavourite ? "star.fill" : "star")
      }
    }
    .symbolRenderingMode(.multicolor)
    .navigationTitle(line.name)
  }
}

struct GoodServiceView: View {
  var body: some View {
    HStack {
      Spacer()
      VStack(spacing: 16) {
        Spacer()
        Image(systemName: "tram.fill")
          .font(.largeTitle)
        Text("Good Service")
          .font(.headline)
        Spacer()
      }
      Spacer()
    }.foregroundColor(.secondary)
  }
}

struct PoorServiceView: View {
  var status: TfLDisruption
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Label(status.statusSeverityDescription, systemImage: "exclamationmark.octagon.fill")
        .font(.headline)
      if let reason = status.reason {
        Text(reason)
          .padding(.top, 4)
          .lineLimit(nil)
      }
    }
    .padding(.vertical, 8)
  }
}
