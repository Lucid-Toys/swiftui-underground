//
//  LineStatusList.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

let favourites = SyncModel()

struct LineStatusList: View {
    @ObservedObject var data: DataFetcher
    
    var body: some View {
        List {
            ForEach(data.lines) { line in
              LineStatusListRow(line: line)
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
        }
        .navigationBarTitle("Underground Status")
    }
}


