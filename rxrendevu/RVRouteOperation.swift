//
//  RVRouteOperation.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

class RVRouteOperation: RVAsyncOperation {
    var level: Int
    var newRoute: RVRoute
    init(level: Int, newRoute: RVRoute) {
        self.level = level
        self.newRoute = newRoute
        super.init()
    }
    override func asyncMain() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.navigator.newRouteInner(level: level, newRoute: newRoute)
            delegate.navigator.routeLock.subscribe(onNext: { _ in
                print("In \(self.classForCoder).asyncMail, subscription callback")
                self.completeOperation()
            }).disposed(by: rx_disposeBag)
        } else {
            print("In \(self.classForCoder).asyncMain, failed to get app delegate")
            completeOperation()
        }

    }
}
