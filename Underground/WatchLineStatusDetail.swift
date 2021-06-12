//
//  ListStatusDetail.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

// swiftlint:disable multiple_closures_with_trailing_closure

import SwiftUI

struct WatchLineStatusDetail: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  var line: TransitLine
  @State var isFavourite: Bool

  // swiftlint:disable identifier_name
  let FavouriteButton: some View = HStack {
    Spacer()
    Image(systemName: "star.fill")
    Text("Unfavourite")
    Spacer()
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        HStack {
          Text(self.line.name)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
          Spacer()
        }
        .padding()
        .background(line.color.opacity(0.5))

        if shouldShowPoorServiceView(self.line.lineStatuses) {
          ForEach(self.line.lineStatuses) { status in
            PoorServiceView(status: status)
          }
        } else {
          GoodServiceView()
        }
      }
      .cornerRadius(8, antialiased: true)

      Spacer()

      Button(action: {
        self.presentationMode.wrappedValue.dismiss()
      }) {
        HStack {
          Spacer()
          Text("Dismiss")
          Spacer()
        }
      }
    }
  }
}
