//
//  ListStatusDetail.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

struct ListStatusDetail: View {
    var line: APIResponse
  
    private func shouldShowPoorServiceView(_ lineStatuses: [TfLDisruption]) -> Bool {
      if(lineStatuses.count > 1 || (line.lineStatuses.count > 1 && line.lineStatuses[0].statusSeverity != 10)) {
        return true
      } else {
        return false
      }
    }
  
    init(line: APIResponse) {
        self.line = line
        // Remove only extra separators below the list:
        #if !os(watchOS)
          UITableView.appearance().tableFooterView = UIView()
        #endif
    }
  
    var body: some View {
        Group {
          Rectangle().fill(TfLLine(id: self.line.id).color)
            .frame(height: 8)
          if self.shouldShowPoorServiceView(self.line.lineStatuses) {
                List(self.line.lineStatuses) { status in
                      PoorServiceView(status: status)
                }.listStyle(PlainListStyle())
              Spacer()
            } else {
                Spacer()
                GoodServiceView()
                Spacer()
            }
        }.navigationBarTitle(self.line.name)
    }
}


struct GoodServiceView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tram.fill")
                .font(.title)
                .foregroundColor(.secondary)
            Text("Good Service")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

struct PoorServiceView: View {
    var status: TfLDisruption
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .font(.headline)
                Text(status.statusSeverityDescription)
                    .font(.headline)
            }
            if status.reason != nil {
                Text(status.reason!)
                    .padding(.top, 4)
                    .lineLimit(100)
            }
        }
        .padding(.vertical)
    }
}

struct ListStatusDetail_Previews: PreviewProvider {
    static var previews: some View {
        ListStatusDetail(line: APIResponse(id: .Bakerloo, name: "Bakerloo (Test)", lineStatuses: [TfLDisruption(lineId: "bakerloo", statusSeverity: 10, statusSeverityDescription: "Good service", reason: nil, created: "N/A")]))
    }
}
