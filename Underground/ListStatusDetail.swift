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
        
        ForEach(line.lineStatuses) { status in
            if status.statusSeverity < 10 {
                ScrollView {
                    VStack {
                        Rectangle().fill(TfLLine(id: self.line.id).color)
                            .frame(height: 8)
                        PoorServiceView(line: self.line)
                    }
                }
            } else {
                Rectangle().fill(TfLLine(id: self.line.id).color)
                    .frame(height: 8)
                Spacer()
                GoodServiceView(line: self.line)
                Spacer()
            }
        }.navigationBarTitle(self.line.name)
        .background(Color("BackgroundWash"))
    }
}


struct GoodServiceView: View {
    var line: APIResponse
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
    var line: APIResponse
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(line.lineStatuses) { status in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.circle")
                            .font(.headline)
                        Text(status.statusSeverityDescription)
                            .font(.headline)
                    }
                    if status.reason != nil {
                        Text(status.reason!)
                            .padding(.top, 8)
                            .lineLimit(100)
                    }
                }
            }
        }
    .padding()
    }
}

struct ListStatusDetail_Previews: PreviewProvider {
    static var previews: some View {
        ListStatusDetail(line: APIResponse(id: .Bakerloo, name: "Bakerloo (Test)", lineStatuses: [TfLDisruption(id: 0, lineId: "bakerloo", statusSeverity: 10, statusSeverityDescription: "Good service", reason: nil, created: "N/A")]))
    }
}
