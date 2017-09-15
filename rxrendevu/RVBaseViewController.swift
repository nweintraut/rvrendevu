//
//  RVBaseViewController.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift 
import NSObject_Rx



class RVBaseViewController: UIViewController, RVControllerProtocol, RVNavigationType, RVPropogateProtocol {
    //var navigator = RVViewDeckNavigator()
    var viewLoadedSubject: PublishSubject<Void> = PublishSubject<Void>()
    private var profile: RVControllerProfile? = nil
    internal        var childControllerProfile: RVControllerProfile?    = nil
    internal weak   var childController:        UIViewController?       = nil
    static let identifier: String = { "\(classForCoder())" }()
    var navigationPath: RVRoutePath!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoadedSubject.onCompleted()
    }
    func installConfig(profile: RVControllerProfile) {
        self.profile = profile
    }
    func getProfile() -> RVControllerProfile? {
        return self.profile
    }
    func newRoute(level: Int, newRoute: RVRoute) -> Void {
        print("IN \(self.classForCoder).RVBaseViewController.newRoute need to implement")
        //self.navigator.newRoute(level: level, newRoute: newRoute)
    }
}


