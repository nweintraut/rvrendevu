//
//  RVUserProfile+RxExtension.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/13/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation
import RxSwift

extension RVUserProfile {
    func emailLookup(email: String, password: String) -> Observable<RVUserProfile> {
        if email.isValidEmail() != nil {
            
        } else if password.isValidPassword() != nil {
            
        }
        return Observable.create({ (Observer) -> Disposable in
            return Disposables.create()
        })
    }
}
