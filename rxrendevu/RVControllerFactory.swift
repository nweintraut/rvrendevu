//
//  RVControllerFactory.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit

class RVControllerFactory: NSObject {
    static let sharedInstance = {return RVControllerFactory() }()
    var storyboards = [String : UIStoryboard]()
    var home: UIViewController!
    var profiles: [RVKey: RVControllerProfile] = [
        .menu   : RVControllerProfile(storyboard: "Main", identifier: RVKey.menu.rawValue),
        .home   : RVControllerProfile(storyboard: "Main", identifier: RVKey.home.rawValue),
        .login  : RVControllerProfile(storyboard: "Main", identifier: RVKey.login.rawValue)
    ]

    func getController(key: RVKey) -> UIViewController? {
        if let profile = profiles[key] {
            return instantiateController(controllerProfile: profile)
        }
        return nil
    }
    func getController(profile: RVControllerProfile) -> UIViewController? {
        if let scene = RVKey(rawValue: profile.identifier) {
            return getController(key: scene)
        }
        return nil
    }
    func getStoryboard(controllerProfile: RVControllerProfile ) -> UIStoryboard {
        if let storyboard = self.storyboards[controllerProfile.storyboard] { return storyboard }
        let storyboard = UIStoryboard(name: controllerProfile.storyboard, bundle: controllerProfile.bundle)
        self.storyboards[controllerProfile.storyboard] = storyboard
        
        return storyboard
    }
    func plug() {
        home = instantiateController(controllerProfile: RVControllerProfile(storyboard: "Main", identifier: RVKey.home.rawValue))
    }
    func instantiateController(controllerProfile: RVControllerProfile) -> UIViewController {
        return getStoryboard(controllerProfile: controllerProfile).instantiateViewController(withIdentifier: controllerProfile.identifier)
    }
    func sameController(newProfile: RVControllerProfile?, candidate: UIViewController?) -> Bool {
        if let candidate = candidate {
            if let newProfile = newProfile {
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
        return false
    }
}
