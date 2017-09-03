//
//  RVUserProfile.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift

class RVUserProfile: RVBaseModel {

    class func getOrCreateUserProfile(username: String) -> Observable<RVUserProfile?> {
        let fields: [String: AnyObject] = ["username" : username as AnyObject]
        return Observable<RVUserProfile?>.create({ (observable: AnyObserver<RVUserProfile?>) -> Disposable in
            if username == "" {
                observable.onError(RVError(message: "In \(classForCoder()).getOrCreateUserProfile, username is empty"))
            } else if username.contains(" ") {
                observable.onError(RVError(message: "In \(classForCoder()).getOrCreateUserProfile, username \(username) contains spaces"))
            } else {
                let _ = RVMeteorService.sharedInstance.call(method: .getOrCreateUserProfile, params: [fields as AnyObject], callback: { (result: Any?, error: RVError?) in
                    if let error = error {
                        error.addMessage(message: "In \(classForCoder()).getOrCreteUserProfile got error")
                        observable.onError(error)
                        return
                    } else if let fields = result as? [String: AnyObject] {
                        observable.onNext(RVUserProfile(fields: fields))
                        observable.onCompleted()
                    } else {
                        observable.onCompleted()
                    }
                })
            }
            return Disposables.create()
        })
    }
    
}
