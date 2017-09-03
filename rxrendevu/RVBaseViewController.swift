//
//  RVBaseViewController.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
class RVBaseViewController: UIViewController {
    private var profile: RVControllerProfile? = nil
    static let identifier: String = { "\(classForCoder())" }()
    func installConfig(profile: RVControllerProfile) {
        
    }
    func getProfile() -> RVControllerProfile? {
        return self.profile
    }
}
