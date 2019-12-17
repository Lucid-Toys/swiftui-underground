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
    case Bakerloo = "bakerloo"
    case Central = "central"
    case Circle = "circle"
    case District = "district"
    case DLR = "dlr"
    case HammersmithCity = "hammersmith-city"
    case Jubilee = "jubilee"
    case Metropolitan = "metropolitan"
    case Northen = "northern"
    case Overground = "london-overground"
    case Piccadilly = "piccadilly"
    case TfLRail = "tfl-rail"
    case Victoria = "victoria"
    case WaterlooCity = "waterloo-city"
}

struct TfLLineColor {
    var color: [TfLLineID:Color] = [
        TfLLineID.Bakerloo: Color(red:0.54, green:0.31, blue:0.14),
        TfLLineID.Central: Color(red:0.87, green:0.15, blue:0.12),
        TfLLineID.Circle: Color(red:0.89, green:0.71, blue:0.00),
        TfLLineID.District: Color(red:0.00, green:0.45, blue:0.16),
        TfLLineID.DLR: Color(red:0.00, green:0.69, blue:0.68),
        TfLLineID.HammersmithCity: Color(red:0.84, green:0.60, blue:0.69),
        TfLLineID.Jubilee: Color(red:0.42, green:0.45, blue:0.47),
        TfLLineID.Metropolitan: Color(red:0.46, green:0.06, blue:0.34),
        TfLLineID.Northen: Color(red:0.10, green:0.10, blue:0.10),
        TfLLineID.Overground: Color(red:0.91, green:0.42, blue:0.06),
        TfLLineID.Piccadilly: Color(red:0.00, green:0.10, blue:0.66),
        TfLLineID.TfLRail: Color(red:0.00, green:0.10, blue:0.66),
        TfLLineID.Victoria: Color(red:0.02, green:0.63, blue:0.89),
        TfLLineID.WaterlooCity: Color(red:0.47, green:0.82, blue:0.74)
    ]
    
    subscript (key:TfLLineID) -> Color {
      get {
        if let newValue = color[key] {
          return newValue
        } else {
          return Color(red:0.00, green:0.00, blue:0.00)
        }
      }
    }
}

struct TfLLine {
    let id: TfLLineID
    let color: Color
    
    init(id: TfLLineID) {
        self.id = id
        self.color = TfLLineColor()[id]
    }
}
