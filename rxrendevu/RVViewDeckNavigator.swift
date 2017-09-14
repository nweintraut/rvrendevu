//
//  RVViewDeckNavigator.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit

class RVViewDeckNavigator: RVBaseNavigator {
    override func setController(key: RVKey, controller: UIViewController, profile: RVControllerProfile) {
        print("In \(self.classForCoder).setController, with profile: \(profile.toString()), key: \(key.rawValue)---------------")
        switch key {
        case .login:
            RVViewDeck.sharedInstance.centerViewController = controller
        default:
            print("In \(self.classForCoder).newRoute, scene: \(key) not implemented")
        }
    }
}
