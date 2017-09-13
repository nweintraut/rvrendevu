//
//  RVMeteorService.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/1/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift
import Action
import SwiftDDP

class RVMeteorService: NSObject {
    static let sharedInstance: RVMeteorService = { return RVMeteorService() }()
    fileprivate let loginObserver: PublishSubject<String> = PublishSubject<String>()
    /*
    let loginAction: Action<(String, String), Bool> = Action { credentials in
        let (login, password) = credentials
    }
 */
    
    func loginService(email: String, password: String) {
        
        /*
        
        let o = Observable.zip(Observable.just(email), Observable.just(password)) { (email, password) in
            return (email: email.lowercased(), password: password)
        }.filter { (email: String, password: String) -> Bool in
            if email.isValidEmail() && password.isValidPassword() {
                return true
            }
            return false
        }.map { (email, password) in
            if !email.isValidEmail() { throw RVError(message: "Bad Email", error: nil) }
            if !password.isValidPassword()  { throw RVError(message: "Bad Password", error: nil) }
            return "OK"
         
        }.catchError {error in
            return Observable<String>.just("Elmo")
        }
        */
        
   //     let q = Observable<String>.zip(email, password)

        /*
        let observable = Observable<String>.combineLatest([email, password]) { (email, password) -> Element in
            print("\($0), \($1)")
        }
 */
    }
    func loginWithPassword(email: String, password: String, callback: @escaping (RVError?) -> Void) {
        if email.isValidEmail() != nil {
            callback(RVError(message: "In \(self.classForCoder).loginWithPassword invalid email: \n\(email.isValidEmail()!)"))
        } else if password.isValidPassword() != nil {
            callback(RVError(message: "In \(self.classForCoder).loginWithPassword invalid password: \n\(password.isValidEmail()!)"))
        } else {
            Meteor.loginWithPassword(email.lowercased(), password: password) { (result, error: DDPError?) in
                let error = RVError.convertDDPError(ddpError: error)
                callback(error)
            }
        }
    }
    fileprivate func loginViaToken(callback: @escaping (RVError?) -> Void) {
        let haveToken = Meteor.client.loginWithToken( { (result, error: DDPError?) in
            let error = RVError.convertDDPError(ddpError: error)
            callback(error)
        })
        if !haveToken { callback(nil) }
    }
    func connect(callback: @escaping() -> Void) {
        let interval: TimeInterval = 4.0
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { (timer) in
            print("In \(self.classForCoder).connect, no newtork connection after \(interval) seconds")
        }
        RVSwiftDDP.connect(RVConfiguration.sharedInstance.baseServer) { 
            timer.invalidate()
            callback()
        }
    }
    func call(method: RVMeteorMethod, params: [AnyObject], callback: @escaping(Any?, RVError?)-> Void) -> String? {
        return RVSwiftDDP.call(method.rawValue, params: params) { (result: Any?, error: DDPError?) in
            let error = RVError.convertDDPError(ddpError: error)
            callback(result, error)
        }
    }
    func findAccountViaEmail(email: String, callback:@escaping (String, RVError?) -> Void) -> String? {
        return self.call(method: RVMeteorMethod.findAccountMethod, params: [["email": email] as AnyObject]) { (result, error) in
            if let error = error {
                callback("", error)
            } else if let result = result as? String {
                print("\(result)")
                callback(result, nil)
            } else {
                print("In \(self.classForCoder), no error but no result")
                callback("", nil)
            }
        }
        
    }
    
}
extension RVMeteorService {

    func rxFindAccountViaEmail(email: String) -> Observable<String> {
        return Observable.create({ (observer) -> Disposable in
            if let message = email.isValidEmail() {
                observer.onError(RVError(message: message))
            } else {
                let _ = self.findAccountViaEmail(email: email, callback: { (emailFound: String, error: RVError?) in
                    if let error = error {
                        observer.onError(error)
                        return
                    } else {
                        observer.onNext(emailFound)
                        observer.onCompleted()
                    }
                })
            }
            /*
            let dummyPassword = "\(Date().timeIntervalSince1970)_dummyPassword"
            Meteor.loginWithPassword(email, password: dummyPassword) { (result, error: DDPError?) in
                if let error: RVError = RVError.convertDDPError(ddpError: error) {
                    observer.onError(error)
                    return
                } else if let result = result {
                    print("In \(self.classForCoder).rxEmailLookup, result is \(result)")
                    observer.onNext("\(result)")
                } else {
                    observer.onNext("No result")
                }
                observer.onCompleted()
            }
            */
            return Disposables.create()
        })
    }
}
extension Reactive where Base: RVMeteorService {
    func loginViaPassword(email: String, password: String) -> Observable<String> {
        return Observable.create({ observer -> Disposable in
            self.base.loginWithPassword(email: email, password: password, callback: { ( error) in
                if let error = error {
                    observer.onError(error)
                    return
                } else {
                    observer.on(.next(""))
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
    func loginViaToken() {
        
    }
    
}
