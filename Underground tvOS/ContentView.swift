//
//  ContentView.swift
//  Underground tvOS
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var fetcher = DataFetcher()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fetcher.lines) { line in
                    NavigationLink(destination: ListStatusDetail(line: line)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Rectangle().fill(Color(TfLLine(id: line.id).color)).frame(height: 8).padding(EdgeInsets(top: -6, leading: -20, bottom: 0, trailing: -100))
                            Text(line.name)
                                .font(.headline)
                            StatusSummary(lineStatuses: line.lineStatuses)
                        }
                    }
                }
            }.navigationBarTitle("Underground Status")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
