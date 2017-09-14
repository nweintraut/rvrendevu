//
//  RVBaseViewDeck.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import ViewDeck

class RVViewDeckController: IIViewDeckController {
    var navigator = RVViewDeckNavigator()
}


extension RVViewDeckController: RVPropogateProtocol {
    func newRoute(level: Int, newRoute: RVRoute) -> Void {
        self.navigator.newRoute(level: level, newRoute: newRoute)
    }
}
