//
//  LineStatusList.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

struct LineStatusList: View {
    @ObservedObject var data: DataFetcher
    @State private var navAccentColor: Color? = .accentColor
    
    var body: some View {
        List {
            ForEach(data.lines) { line in
                NavigationLink(destination: ListStatusDetail(line: line)) {
                    HStack() {
                        Rectangle().fill(TfLLine(id: line.id).color)
                            .frame(width: 8)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(line.name)
                                .font(.headline)
                            StatusSummary(lineStatuses: line.lineStatuses)
                        }.padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                    }
                }
                
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
        }
        .navigationBarTitle("Underground Status")
    }
}

struct StatusSummary: View {
    var lineStatuses: [TfLDisruption]
    var body: some View {
        ForEach(lineStatuses) { status in
            if status.statusSeverityDescription != "Good Service" {
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
                Text(status.statusSeverityDescription)
                    .font(.subheadline)
                Image(systemName: "exclamationmark.triangle")
            }.foregroundColor(status.statusSeverity < 6 ? .red : .yellow)
            if status.reason != nil {
                Text(status.reason!)
                    .lineLimit(2)
            }
        }
    }
}

struct GoodStatusSummary: View {
    var status: TfLDisruption
    var body: some View {
        Text(status.statusSeverityDescription)
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
}

struct LineStatusList_Previews: PreviewProvider {
    static var previews: some View {
        LineStatusList(data: DataFetcher())
    }
}
