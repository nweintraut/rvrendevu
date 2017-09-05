//
//  RVRoutePath.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/3/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation
class RVRoutePath {
    var scene: RVKey
    var parameter: String?
    var model: RVBaseModel?
    init(scene: RVKey, parameter: String?, model: RVBaseModel?) {
        self.scene = scene
        self.parameter = parameter
        self.model = model
    }
}
