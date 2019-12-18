//
//  DeviceModel.swift
//  Underground
//
//  Created by Daniel Eden on 18/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import Foundation
import Combine

final class DeviceModel: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()

    var isLandscape: Bool = false { willSet { objectWillChange.send() } }
}
