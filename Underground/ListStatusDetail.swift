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
    var body: some View {
        VStack {
            Rectangle().fill(TfLLine(id: line.id).color)
                .frame(height: 8)
            ForEach(line.lineStatuses) { status in
                if status.statusSeverityDescription != "Good Service" {
                    PoorServiceView(line: self.line)
                } else {
                    Spacer()
                    GoodServiceView(line: self.line)
                    Spacer()
                }
            }
        }
        .navigationBarTitle(line.name)
    }
}

struct GoodServiceView: View {
    var line: APIResponse
    var body: some View {
        ForEach(line.lineStatuses) { status in
            VStack(spacing: 16) {
                Image(systemName: "tram.fill")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(status.statusSeverityDescription)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PoorServiceView: View {
    var line: APIResponse
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(line.lineStatuses) { status in
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .font(.title)
                    Text(status.statusSeverityDescription)
                        .font(.title)
                }
                if status.reason != nil {
                    Text(status.reason!)
                        .padding(.top, 8)
                        .lineLimit(100)
                }
            }
        }
    }
}

struct ListStatusDetail_Previews: PreviewProvider {
    static var previews: some View {
        ListStatusDetail(line: APIResponse(id: .Bakerloo, name: "Bakerloo (Test)", lineStatuses: [TfLDisruption(id: 0, lineId: "bakerloo", statusSeverity: 10, statusSeverityDescription: "Good service", reason: nil, created: "N/A")]))
    }
}
