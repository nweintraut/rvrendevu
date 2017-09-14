//
//  RVNavigator.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit

class RVBaseNavigator: NSObject {
    var level: Int = 0
    var priorRoute: RVRoute?
    var currentRoute: RVRoute?
//    var currentViewController: UIViewController? = nil
         var childProfile:      RVControllerProfile? = nil
    weak var childController:   UIViewController? = nil
    func nextLevel(level: Int) -> Int {
        return level + 1
    }
    func propogateToChild(level: Int, newRoute: RVRoute) {
        if let childController = self.childController as? RVPropogateProtocol {
            childController.newRoute(level: level, newRoute: newRoute)
        } else if let childController = self.childController {
            print("In \(self.classForCoder).propogateToChild, controller \(childController) does not conform to RVPropogateProtocol")
        } else {
            print("In \(self.classForCoder).postInstallProcessing, no child controller")
        }
    }
    func newRoute(level: Int, newRoute: RVRoute) {
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
        postInstallProcessing(level: level, newRoute: newRoute)
    }
    func installController(profile: RVControllerProfile) {
        print("In \(self.classForCoder).installController with profile: \(profile.toString())")
        if let controller = RVControllerFactory.sharedInstance.getController(profile: profile) {
            if let key = RVKey(rawValue: profile.identifier) {
                self.childProfile    = profile
                self.childController = controller
                self.setController(key: key, controller: controller, profile: profile)
            } else {
                print("In \(self.classForCoder).installController, did not have controller for \(profile.toString())")
            }
        } else {
            print("In \(self.classForCoder).installController, \(profile.identifier) did not convert to RVKey")
        }
    }
    func postInstallProcessing(level: Int, newRoute: RVRoute) {
        self.priorRoute = self.currentRoute
        self.currentRoute = newRoute
        self.level = level
        self.propogateToChild(level: nextLevel(level: level), newRoute: newRoute)
    }
    func setController(key: RVKey, controller: UIViewController, profile: RVControllerProfile) {
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



