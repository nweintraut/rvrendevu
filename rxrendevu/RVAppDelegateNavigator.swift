//
//  RVAppDelegateNavigator.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit

class RVAppDelegateNavigator: RVBaseNavigator {
    override func newRoute(level: Int, newRoute: RVRoute) {
        if level == 0 {
            if let path = newRoute.getPath(level: level) {
                if let profile = RVControllerFactory.sharedInstance.getProfile(key: path.scene) {
                    if let currentProfile = self.childProfile {
                        if currentProfile.match(candidate: profile) {
                            if self.childController != nil {
                                /// same as beforem so just fall through to end
                            } else {
                                print("In \(self.classForCoder).newRoute, have odd state of currentProfile but no current Controller")
                                installController(profile: profile)
                            }
                        } else {
                            // new/different Controller
                            installController(profile: profile)
                        }
                    } else {
                        // Nothing exists previously
                        installController(profile: profile)
                    }
                } else {
                    print("In \(self.classForCoder).newRoute, did not find profile for \(path.scene)")
                }
            } else {
                print("In \(self.classForCoder).newRoute, no path at level \(level)")
            }
        } else {
            print("In \(self.classForCoder).newRoute, level must be zero, was \(level)")
        }
        postInstallProcessing(level: level, newRoute: newRoute)
    }
    override func setController(key: RVKey, controller: UIViewController, profile: RVControllerProfile) {
        switch key {
        case .viewDeck:
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                if let window = delegate.window {
                    window.rootViewController = controller
                    
                } else {
                    print("In \(self.classForCoder).newRoute, failed to get Windown from AppDelegate")
                }
            } else {
                print("In \(self.classForCoder).newRoute, failed to get AppDelegate")
            }
        default:
            print("In \(self.classForCoder).newRoute, scene: \(key) not implemented")
        }
    }
}
