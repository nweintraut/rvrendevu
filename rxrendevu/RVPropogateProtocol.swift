//
//  RVPropogateProtocol.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation
protocol RVPropogateProtocol: class {
    func newRoute(level: Int, newRoute: RVRoute) -> Void
}
