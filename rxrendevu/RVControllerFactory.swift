//
//  RVControllerFactory.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit

class RVControllerFactory {
    static let sharedInstance = {return RVControllerFactory() }()

    var profiles: [RVKey: RVControllerProfile] = [
        .menu : RVControllerProfile(storyboard: "Main", identifier: RVKey.menu.rawValue),
        .home : RVControllerProfile(storyboard: "Main", identifier: RVKey.home.rawValue),
    ]

    func getController(key: RVKey) -> UIViewController? {
        if let profile = profiles[key] {
            return instantiateController(identifier: profile)
        }
        return nil

    }
    func instantiateController(identifier: RVControllerProfile) -> UIViewController {
        return UIStoryboard(name: identifier.storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier.identifier)
    }
    func sameController(newProfile: RVControllerProfile, candidate: UIViewController) -> Bool {
        var candidateProfile: RVControllerProfile? = nil
        if let nav = candidate as? RVBaseNavController {
            candidateProfile = nav.getProfile()
        } else if let tab = candidate as? RVBaseTabBarViewController {
            candidateProfile = tab.getProfile()
        } else if let controller = candidate as? RVBaseViewController {
            candidateProfile = controller.getProfile()
        }
        if let candidateProfile = candidateProfile {
            return newProfile.match(candidate: candidateProfile)
        }
        return false
    }

}
