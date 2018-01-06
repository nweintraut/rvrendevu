//
//  RVBaseTabViewController.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
class RVBaseTabBarViewController: UITabBarController, RVNavigationType {
    private var profile: RVControllerProfile? = nil
    var navigationPath: RVRoutePath!
    func installConfig(profile: RVControllerProfile) {
        self.profile = profile
    }
    func getProfile() -> RVControllerProfile? {
        return self.profile
    }
}
