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
  var status: LoadingState<[TransitLine]>
  var lastUpdated: Date
  let formatter = DateFormatter()

  init(status: LoadingState<[TransitLine]>, lastUpdated: Date) {
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    self.status = status
    self.lastUpdated = lastUpdated
  }
  
  var iconName: String {
    switch status {
    case .loading:
      return "arrow.2.circlepath"
    case .offline:
      return "wifi.slash"
    default:
      return "wifi"
    }
  }
  
  var statusString: String {
    switch status {
    case .loading:
      return "Fetching latest status..."
    case .offline:
      return "Currently offline"
    default:
      return "Updating live"
    }
  }

  var body: some View {
    Label(statusString, systemImage: iconName)
      .font(.caption)
      .foregroundColor(.secondary)
      .labelStyle(.titleAndIcon)
  }
}

struct UpdatingLiveIndicator_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 2) {
      UpdatingLiveIndicator(status: .loading, lastUpdated: Date())
      UpdatingLiveIndicator(status: .offline, lastUpdated: Date())
    }
    .previewDevice(.none)
    .previewLayout(.sizeThatFits)
  }
}
