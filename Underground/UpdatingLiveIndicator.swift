//
//  UpdatingLiveIndicator.swift
//  Underground
//
//  Created by Daniel Eden on 20/01/2020.
//  Copyright © 2020 Daniel Eden. All rights reserved.
//

import SwiftUI

struct UpdatingLiveIndicator: View {
  @State var opacity = 1.0
  @State var rotationAmount = -360.0
  var status: DataState
  var lastUpdated: Date
  let formatter = DateFormatter()

  init(status: DataState, lastUpdated: Date) {
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    self.status = status
    self.lastUpdated = lastUpdated
  }

  var body: some View {
    HStack {
      if status == .offline {
        HStack(alignment: .top) {
          Image(systemName: "wifi.slash")
          VStack(alignment: .leading) {
            Text("Currently offline")
              .fontWeight(.bold)
            #if !os(watchOS)
            Text("Last updated at \(formatter.string(from: self.lastUpdated))")
            #endif
          }
        }
      } else if status == .loading {
        HStack {
          Image(systemName: "arrow.2.circlepath")
            .rotationEffect(Angle(degrees: rotationAmount))
            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
            .onAppear {
              self.rotationAmount = 0
          }
          Text("Fetching status...")
        }
      } else if status == .spotty {
        HStack(alignment: .top) {
          Image(systemName: "wifi.exclamationmark")
            .padding(.top, 2)
          VStack(alignment: .leading) {
            Text("Still trying...")
              .fontWeight(.bold)
            #if !os(watchOS)
            Text("Last updated at \(formatter.string(from: self.lastUpdated))")
            #endif
          }
        }
      } else {
        HStack {
          Image(systemName: "wifi")
          Text("Updating Live")
        }
      }
      Spacer()
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .background(status != .offline ? .clear : Color("Yellow"))
    .foregroundColor(status != .offline ? .secondary : .black)
    .font(.caption)
  }
}

struct UpdatingLiveIndicator_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 2) {
      UpdatingLiveIndicator(status: .loading, lastUpdated: Date())
      UpdatingLiveIndicator(status: .loaded, lastUpdated: Date())
      UpdatingLiveIndicator(status: .spotty, lastUpdated: Date())
      UpdatingLiveIndicator(status: .offline, lastUpdated: Date())
    }
    .previewDevice(.none)
    .previewLayout(.sizeThatFits)
  }
}
