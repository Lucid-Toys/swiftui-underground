//
//  LineStatusListRow.swift
//  Underground
//
//  Created by Daniel Eden on 20/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

struct LineStatusListRow: View {
  var line: APIResponse
  var isFavourite: Bool
  @State var isPresented = false
  
  var body: some View {
    Button(action: {
      self.isPresented.toggle()
    }) {
      VStack(spacing: 0) {
        Rectangle().fill(TfLLine(id: line.id).color)
          .frame(height: 8)
        VStack(alignment: .leading, spacing: 2) {
          HStack {
            Text(line.name)
              .font(.headline)
              .lineLimit(1)
            Spacer()
            if isFavourite {
              Image(systemName: "star.fill")
                .foregroundColor(.secondary)
                .font(.caption)
            }
          }
          StatusSummary(lineStatuses: line.lineStatuses)
        }.padding(8)
      }
    .contentShape(Rectangle())
    }
    .buttonStyle(PlainButtonStyle())
    .background(Color("SecondaryBackground"))
    .foregroundColor(.primary)
    .cornerRadius(12)
    .sheet(isPresented: $isPresented) {
      #if !os(watchOS)
      ListStatusDetail(line: self.line, isFavourite: self.isFavourite)
      #else
      WatchLineStatusDetail(line: self.line, isFavourite: self.isFavourite)
      #endif
    }
  }
}

struct StatusSummary: View {
  var lineStatuses: [TfLDisruption]
  var body: some View {
    ForEach(lineStatuses) { status in
      if status.statusSeverity != 10 {
        PoorStatusSummary(status: status)
      } else {
        GoodStatusSummary(status: status)
      }
    }
  }
}

struct PoorStatusSummary: View {
  var status: TfLDisruption
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      HStack(spacing: 4) {
        Image(systemName: "exclamationmark.triangle.fill")
          .font(.caption)
        Text(status.statusSeverityDescription)
          .font(.subheadline)
          .lineLimit(1)
      }
      .foregroundColor(status.statusSeverity < 6 ? Color("Red") : Color("Yellow"))
      if status.reason != nil {
        Text(status.reason!)
          .lineLimit(2)
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
  }
}

struct GoodStatusSummary: View {
  var status: TfLDisruption
  var body: some View {
    Text(status.statusSeverityDescription)
      .font(.caption)
      .foregroundColor(.secondary)
  }
}

struct LineStatusList_Previews: PreviewProvider {
  static var previews: some View {
    LineStatusList(data: UndergroundDataFetcher())
  }
}

//struct LineStatusListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        LineStatusListRow()
//    }
//}
