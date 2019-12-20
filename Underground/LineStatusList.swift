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
    let favourites = UserDefaults.standard.object(forKey: "syncFavourites") as? [String] ?? [String]()
    
    var body: some View {
        List {
            ForEach(data.lines) { line in
                LineStatusListRow(line: line, isFavourite: self.favourites.contains(line.id.rawValue))
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
        }
        .navigationBarTitle("Underground Status")
    }
}


