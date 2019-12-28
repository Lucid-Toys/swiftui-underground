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
    @State var isFavourite: Bool
    
    var body: some View {
        NavigationLink(destination: ListStatusDetail(line: line)) {
            HStack() {
                Rectangle().fill(TfLLine(id: line.id).color)
                    .frame(width: 8)
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
            }.contextMenu {
                Button(action: { self.toggleFavourite() }) {
                    Image(systemName: isFavourite ? "star.slash.fill" : "star")
                    Text(isFavourite ? "Unfavourite Line" : "Favourite Line")
                }
            }
        }
    }
    
    func toggleFavourite() -> Void {
      var favouritesArray = favourites.get()
        if let i = favouritesArray.firstIndex(of: self.line.id.rawValue) {
            favouritesArray.remove(at: i)
        } else {
            favouritesArray.append(self.line.id.rawValue)
        }
        favouritesArray.sort()
        favourites.set(favouritesArray)
        self.isFavourite.toggle()
        print(favouritesArray)
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
                Text(status.statusSeverityDescription)
                    .font(.subheadline)
                    .lineLimit(1)
                Image(systemName: "exclamationmark.triangle")
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
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
}

struct LineStatusList_Previews: PreviewProvider {
    static var previews: some View {
        LineStatusList(data: DataFetcher())
    }
}

//struct LineStatusListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        LineStatusListRow()
//    }
//}
