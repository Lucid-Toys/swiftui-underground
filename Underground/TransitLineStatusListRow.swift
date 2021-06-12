//
//  LineStatusListRow.swift
//  Underground
//
//  Created by Daniel Eden on 20/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

struct TransitLineStatusListRow: View {
  @EnvironmentObject var lineViewModel: TransitLineViewModel
  
  var line: TransitLine
  
  var isFavourite: Bool {
    lineViewModel.favouriteLineIDs.contains(line.id.rawValue)
  }

  var body: some View {
    NavigationLink(destination: TransitLineDetailView(line: line)) {
      VStack(alignment: .leading, spacing: 4) {
        Label(
          title: { Text(line.name) },
          icon: { Image(systemName: isFavourite ? "star.square.fill" : "square.fill").foregroundColor(line.color) }
        )
          .font(.headline)
          .lineLimit(1)
        StatusSummary(lineStatuses: line.lineStatuses)
      }
    }
  }
}

struct StatusSummary: View {
  enum Severity {
    case high, medium, low
  }
  
  var lineStatuses: [TfLDisruption]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      ForEach(lineStatuses) { status in
        if let severity = getSeverity(for: status) {
          Label(status.statusSeverityDescription,
                systemImage: (severity == .high || severity == .medium) ? "exclamationmark.triangle" : "checkmark" )
            .font(.footnote)
            .foregroundColor(
              status.statusSeverity < 6
                ? Color("Red")
                : status.statusSeverity < 10
                ? Color("Yellow")
                : .secondary
            )
        }
      }
    }
  }
  
  func getSeverity(for status: TfLDisruption) -> Severity {
    switch status.statusSeverity {
    case let x where x < 6:
      return .high
    case let x where (x < 10 || x == 20):
      return .medium
    default:
      return .low
    }
  }
}

struct LineStatusList_Previews: PreviewProvider {
  static var previews: some View {
    TransitLineStatusList()
      .environmentObject(TransitLineViewModel.shared)
  }
}

//struct LineStatusListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        LineStatusListRow()
//    }
//}
