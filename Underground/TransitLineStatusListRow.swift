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
    lineViewModel.isFavourite(lineId: line.id)
  }

  var body: some View {
    NavigationLink(destination: TransitLineDetailView(line: line).environmentObject(lineViewModel)) {
      HStack {
        Group {
          if isFavourite {
            Label(line.name, systemImage: "star.fill")
          } else {
            Text(line.name)
          }
        }
          .font(.headline)
          .lineLimit(2)
        Spacer()
        StatusSummary(line: line)
      }.foregroundStyle(.white)
    }
    .listRowBackground(line.color)
  }
}

struct StatusSummary: View {
  var line: TransitLine
  
  var status: TfLDisruption? {
    line.mostSevereStatus
  }
  
  var severity: TransitLine.DisruptionSeverity {
    line.mostSevereDisruptionSeverity
  }
  
  var body: some View {
    if let status = status {
      Label(status.statusSeverityDescription,
            systemImage: (severity == .high || severity == .medium) ? "exclamationmark.triangle" : "checkmark" )
        .labelStyle(.iconOnly)
        .symbolVariant(severity == .high ? .fill : .none)
    }
  }
}

struct LineStatusList_Previews: PreviewProvider {
  static var previews: some View {
    TransitLineStatusList()
      .environmentObject(TransitLineViewModel())
  }
}

//struct LineStatusListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        LineStatusListRow()
//    }
//}
