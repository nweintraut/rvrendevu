//
//  RVNavigator.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

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
        print("In \(self.classForCoder).newRoute, level: \(level), newRoute: \(newRoute)")
            if let path = newRoute.getPath(level: level) {
                if let profile = RVControllerFactory.sharedInstance.getProfile(key: path.scene) {
                    if let currentProfile = self.childProfile {
                        if currentProfile.match(candidate: profile) {
                            if self.childController != nil {
                                /// same as before
                                postInstallProcessing(level: level, newRoute: newRoute)
                            } else {
                                print("In \(self.classForCoder).newRoute, have odd state of currentProfile but no current Controller")
                                installAndSubscribe(level: level, newRoute: newRoute, profile: profile)
                            }
                        } else {
                            // new/different Controller
                           installAndSubscribe(level: level, newRoute: newRoute, profile: profile)
                        }
                    } else {
                        // Nothing exists previously
                        installAndSubscribe(level: level, newRoute: newRoute, profile: profile)
                    }
                } else {
                    print("In \(self.classForCoder).newRoute, did not find profile for \(path.scene)")
                }
            } else {
                print("In \(self.classForCoder).RVNavigator.newRoute, no path at level \(level)")
                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                    delegate.navigator.routeLock.onNext()
                }
            }
    }
    func installAndSubscribe(level: Int, newRoute: RVRoute, profile: RVControllerProfile) {
        installController(profile: profile)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { _ in
            print("In \(self.classForCoder).installAndSubscribe got an OnNext; shouldn't get this")
        }, onError: { (error) in
            if let error = error as? RVError {
                print("In \(self.classForCoder).installAndSubscribe, got error: \(error.toString())")
            }
        }, onCompleted: {
            DispatchQueue.main.async {
                print("IN \(self.classForCoder).installAndSubscribe got onCompleted-----------------------------")
                self.postInstallProcessing(level: level, newRoute: newRoute)
            }
        }).disposed(by: self.rx_disposeBag)
    }
    func installController(profile: RVControllerProfile) -> Observable<Void> {
        print("In \(self.classForCoder).installController with profile: \(profile.toString())")
        let subject = PublishSubject<Void>()
        if let controller = RVControllerFactory.sharedInstance.getController(profile: profile) {
            if let key = RVKey(rawValue: profile.identifier) {
                self.childProfile    = profile
                self.childController = controller
                return self.setController(key: key, controller: controller, profile: profile)
            } else {
                print("In \(self.classForCoder).installController, did not have controller for \(profile.toString())")
                subject.onError(RVError(message: "In \(self.classForCoder).installController, did not have controller for \(profile.toString())"))
            }
        } else {
            print("In \(self.classForCoder).installController, \(profile.identifier) did not convert to RVKey")
            subject.onError(RVError(message: "In \(self.classForCoder).installController, did not have controller for \(profile.toString())"))
        }
        return subject.shareReplay(1).ignoreElements()
    }
    func postInstallProcessing(level: Int, newRoute: RVRoute) {
        self.priorRoute = self.currentRoute
        self.currentRoute = newRoute
        self.level = level
        self.propogateToChild(level: nextLevel(level: level), newRoute: newRoute)
    }
    func setController(key: RVKey, controller: UIViewController, profile: RVControllerProfile) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        switch key {
        case .viewDeck:
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                if let window = delegate.window {
                    if let nav = controller as? UINavigationController {
                        // one-off subscription to be notified when push complete
                        _ = nav.rx.delegate
                            .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                            .map{ _ in }
                            .bind(to: subject)
                    } else if let controller = controller as? RVPropogateProtocol {
                        _ = controller.viewLoadedSubject
                        .observeOn(MainScheduler.instance)
                        .bind(to: subject)
                    }
                    window.rootViewController = controller
                    subject.onCompleted()
                } else {
                    print("In \(self.classForCoder).newRoute, failed to get Windown from AppDelegate")
                    subject.onError(RVError(message: "In \(self.classForCoder).newRoute, failed to get Windown from AppDelegate"))
                }
            } else {
                print("In \(self.classForCoder).newRoute, failed to get AppDelegate")
                subject.onError(RVError(message: "In \(self.classForCoder).newRoute, failed to get AppDelegate"))
            }
        default:
            print("In \(self.classForCoder).newRoute, scene: \(key) not implemented")
            subject.onError(RVError(message: "In \(self.classForCoder).newRoute, scene: \(key) not implemented"))
        }
        return subject
    }
}



