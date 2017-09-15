//
//  RVAppDelegateNavigator.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift
struct RVrouteInHolding {
    var level: Int
    var newRoute: RVRoute
    init(level: Int, newRoute: RVRoute) {
        self.level = level
        self.newRoute = newRoute
    }
}
class RVAppDelegateNavigator: RVBaseNavigator {
    let routeLock = PublishSubject<Void>()
    var inprocess: Bool = false
    var pendings = [RVrouteInHolding]()
    override func newRoute(level: Int, newRoute: RVRoute) {
        if !inprocess {
            self.inprocess = true
            if pendings.count == 0 {
               self.newRouteInner(level: level, newRoute: newRoute)
            } else {
                var clone = Array(self.pendings)
                clone.append(RVrouteInHolding(level: level, newRoute: newRoute))
                let next = clone.remove(at: 0)
                pendings = clone
                self.newRouteInner(level: next.level, newRoute: next.newRoute)
            }
        } else if pendings.count < 10 {
            var clone = Array(self.pendings)
            clone.append(RVrouteInHolding(level: level, newRoute: newRoute))
            pendings = clone
        }
    }
    override init() {
        super.init()
        routeLock
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.inprocess = false
                print("in \(self.classForCoder).init, subscription onNext")
                DispatchQueue.main.async {
                    if !self.inprocess {
                        self.inprocess = true
                        if self.pendings.count > 0 {
                            var clone = Array(self.pendings)
                            let holding = clone.remove(at: 0)
                            self.pendings = clone
                            self.newRouteInner(level: holding.level, newRoute: holding.newRoute)
                        } else {
                            self.inprocess = false
                        }
                    }
                }
        }).disposed(by: rx_disposeBag)
    }

    func newRouteInner(level: Int, newRoute: RVRoute) {
        print("In \(self.classForCoder).newRoute level: \(level)")
        if level == 0 {
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
                print("In \(self.classForCoder).newRoute, no path at level \(level)")
            }
        } else {
            print("In \(self.classForCoder).newRoute, level must be zero, was \(level)")
        }
    }
    
    
    override func setController(key: RVKey, controller: UIViewController, profile: RVControllerProfile) -> Observable<Void> {
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
                  //  subject.onCompleted()
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
