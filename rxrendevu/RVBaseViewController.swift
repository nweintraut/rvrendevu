//
//  RVBaseViewController.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import NSObject_Rx

class RVBaseViewController: UIViewController, RVControllerProtocol {
    private var profile: RVControllerProfile? = nil
    internal        var childControllerProfile: RVControllerProfile?    = nil
    internal weak   var childController:        UIViewController?       = nil
    static let identifier: String = { "\(classForCoder())" }()
    
    
    func installConfig(profile: RVControllerProfile) {
        self.profile = profile
    }
    func getProfile() -> RVControllerProfile? {
        return self.profile
    }
}
