//
//  RVLoginViewModel.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/13/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift
import Action
import NSObject_Rx

class RVLoginViewModel: RVBaseViewModel {
    override init() {
        super.init()
        bindOutput()
    }

    lazy var loginAction: Action<(String, String), String> = { this in
        return Action { (email: String, password: String) in
            let bag: DisposeBag = this.rx_disposeBag
            return Observable<String>.create({ (observer) -> Disposable in
                RVMeteorService.sharedInstance.rx.loginViaPassword(email: email, password: password)
                    .subscribe(onNext: { (result) in
                        var report = ""
                        if let result = result as? [String: AnyObject] { report = email }
                        observer.onNext(report)
                        observer.onCompleted()
                    }, onError: { (error) in
                        observer.onError(error)
                    }).disposed(by: bag)
                return Disposables.create()
            })
        }
    }(self)
}
