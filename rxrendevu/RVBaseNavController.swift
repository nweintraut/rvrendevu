//
//  RVBaseNavController.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
class RVBaseNavController: UINavigationController {
    private var profile: RVControllerProfile? = nil
    func installConfig(profile: RVControllerProfile) {
        self.profile = profile
    }
    func getProfile() -> RVControllerProfile? {
        return self.profile
    }
}
