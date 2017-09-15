//
//  RVViewDeckNavigator.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RVViewDeckNavigator: RVBaseNavigator {
    
    override func setController(key: RVKey, controller: UIViewController, profile: RVControllerProfile) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        switch key {
        case .login:
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
            RVViewDeck.sharedInstance.centerViewController = controller

        default:
            print("In \(self.classForCoder).newRoute, scene: \(key) not implemented")
            subject.onError(RVError(message: "In \(self.classForCoder).newRoute, scene: \(key) not implemented"))
        }
        return subject
    }
    
}
