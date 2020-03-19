//
//  TfLLine.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import Foundation
import SwiftUI

enum TfLLineID: String, Decodable {
    case bakerloo = "bakerloo"
    case central = "central"
    case circle = "circle"
    case district = "district"
    case DLR = "dlr"
    case hammersmithCity = "hammersmith-city"
    case jubilee = "jubilee"
    case metropolitan = "metropolitan"
    case northen = "northern"
    case overground = "london-overground"
    case piccadilly = "piccadilly"
    case tfLRail = "tfl-rail"
    case victoria = "victoria"
    case waterlooCity = "waterloo-city"
}

struct TfLLineColor {
    var color: [TfLLineID: Color] = [
        TfLLineID.bakerloo: Color(red: 0.54, green: 0.31, blue: 0.14),
        TfLLineID.central: Color(red: 0.87, green: 0.15, blue: 0.12),
        TfLLineID.circle: Color(red: 0.89, green: 0.71, blue: 0.00),
        TfLLineID.district: Color(red: 0.00, green: 0.45, blue: 0.16),
        TfLLineID.DLR: Color(red: 0.00, green: 0.69, blue: 0.68),
        TfLLineID.hammersmithCity: Color(red: 0.84, green: 0.60, blue: 0.69),
        TfLLineID.jubilee: Color(red: 0.42, green: 0.45, blue: 0.47),
        TfLLineID.metropolitan: Color(red: 0.46, green: 0.06, blue: 0.34),
        TfLLineID.northen: Color(red: 0.10, green: 0.10, blue: 0.10),
        TfLLineID.overground: Color(red: 0.91, green: 0.42, blue: 0.06),
        TfLLineID.piccadilly: Color(red: 0.10, green: 0.2, blue: 0.8),
        TfLLineID.tfLRail: Color(red: 0.00, green: 0.10, blue: 0.66),
        TfLLineID.victoria: Color(red: 0.02, green: 0.63, blue: 0.89),
        TfLLineID.waterlooCity: Color(red: 0.47, green: 0.82, blue: 0.74)
    ]

    subscript (key: TfLLineID) -> Color {
      // swiftlint:disable implicit_getter
      get {
        if let newValue = color[key] {
          return newValue
        } else {
          return Color(red: 0.00, green: 0.00, blue: 0.00)
        }
      }
    }
}

struct TfLLine {
    let lineId: TfLLineID
    let color: Color

    init(lineId: TfLLineID) {
        self.lineId = lineId
        self.color = TfLLineColor()[lineId]
    }
}
