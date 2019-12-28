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
    @State var isFavourite: Bool
  
    private func shouldShowPoorServiceView(_ lineStatuses: [TfLDisruption]) -> Bool {
      if(lineStatuses.count > 1 || (line.lineStatuses.count >= 1 && line.lineStatuses[0].statusSeverity != 10)) {
        return true
      } else {
        return false
      }
    }
  
    init(line: APIResponse, isFavourite: Bool) {
        self.line = line
        self._isFavourite = State(initialValue: isFavourite)
        // Remove only extra separators below the list:
        #if !os(watchOS)
          UITableView.appearance().tableFooterView = UIView()
        #endif
    }
  
    var body: some View {
        #if os(watchOS)
        return Content
        #else
        return Content.navigationBarItems(trailing: Button(action: toggleFavourite) {
            Image(systemName: isFavourite ? "star.fill" : "star")
        })
        #endif
    }
    
    var Content: some View {
        Group {
          Rectangle().fill(TfLLine(id: self.line.id).color)
            .frame(height: 8)
          if self.shouldShowPoorServiceView(self.line.lineStatuses) {
                List(self.line.lineStatuses) { status in
                      PoorServiceView(status: status)
                }.listStyle(PlainListStyle())
            } else {
                Spacer()
                GoodServiceView()
                Spacer()
            }
        }.navigationBarTitle(self.line.name)
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
        ListStatusDetail(line: APIResponse(id: .Bakerloo, name: "Bakerloo (Test)", lineStatuses: [TfLDisruption(lineId: "bakerloo", statusSeverity: 10, statusSeverityDescription: "Good service", reason: nil, created: "N/A")]), isFavourite: true)
    }
}
