//
//  AppDelegate+Extension.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift

extension AppDelegate {
    func launchNavigation() {
        configureBaseWindow()
        let route = RVRoute()
            .appendPath(path: RVRoutePath(scene: .viewDeck, parameter: nil, model: nil) )
            .appendPath(path: RVRoutePath(scene: .login, parameter: nil, model: nil))
        self.navigator.newRoute(level: 0, newRoute: route)
    }
    func configureBaseWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.tintColor = RVConfiguration.sharedInstance.windowTintColor
        window.makeKeyAndVisible()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //UISearchBar.appearance().tintColor = UIColor.white
        //UISearchBar.appearance().barTintColor = UIColor.facebookBlue()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.facebookBlue()
    }
    
}
