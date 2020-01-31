//
//  ListStatusDetail.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

#if os(watchOS)
  typealias ContainerView = ScrollView
#else
  typealias ContainerView = Group
#endif

func shouldShowPoorServiceView(_ lineStatuses: [TfLDisruption]) -> Bool {
  if(lineStatuses.count > 1 || (lineStatuses.count >= 1 && lineStatuses[0].statusSeverity != 10)) {
    return true
  } else {
    return false
  }
}

struct ListStatusDetail: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  var line: APIResponse
  @State var isFavourite: Bool
  
  private func shouldShowPoorServiceView(_ lineStatuses: [TfLDisruption]) -> Bool {
    if(lineStatuses.count > 1 || (line.lineStatuses.count >= 1 && line.lineStatuses[0].statusSeverity != 10)) {
      return true
    } else {
      return false
    }
  }
  
  var body: some View {
    ContainerView {
      HStack {
        Text(self.line.name)
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)
        Spacer()
      }
      .padding()
      .background(TfLLine(id: self.line.id).color.opacity(0.9))
      .background(Color.black)
      VStack(alignment: .leading) {
        VStack(alignment: .leading) {
          if self.shouldShowPoorServiceView(self.line.lineStatuses) {
            ForEach(self.line.lineStatuses) { status in
              PoorServiceView(status: status)
            }
          } else {
            GoodServiceView()
          }
        }
        
        Spacer()
        
        Button(action: {
          self.toggleFavourite()
        }) {
          if(self.isFavourite) {
            HStack {
              Spacer()
              Image(systemName: "star.fill")
              Text("Unfavourite")
              Spacer()
            }
          } else {
            HStack {
              Spacer()
              Image(systemName: "star")
              Text("Favourite")
              Spacer()
            }
          }
        }
        .padding()
        .background(self.isFavourite ? Color("Interactive") : Color("TertiaryBackground"))
        .foregroundColor(self.isFavourite ? .white : .accentColor)
        .cornerRadius(8)
        
        Button(action: {
          self.presentationMode.wrappedValue.dismiss()
        }) {
          HStack {
            Spacer()
            Text("Dismiss")
            Spacer()
          }
        }
        .padding()
        .background(Color("TertiaryBackground"))
        .cornerRadius(8)
      }
      .padding()
    }
    .background(Color("SecondaryBackground"))
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
    HStack {
      Spacer()
      VStack(spacing: 16) {
        Spacer()
        Image(systemName: "tram.fill")
          .font(.title)
          .foregroundColor(.secondary)
        Text("Good Service")
          .font(.headline)
          .foregroundColor(.secondary)
        Spacer()
      }
      Spacer()
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
