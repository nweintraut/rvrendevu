//
//  RXSwiftDDP.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/1/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import SwiftDDP
import RxSwift
import RxCocoa

enum RVSwiftDDPErrorReason: String {
    case Incorrect_Password = "Incorrect password"
    case User_Not_Found     = "User not found"
}

class RVSwiftDDP: Meteor {
    class func classForCoder() -> String { return "RVSwiftDDP" }
    static var bag = DisposeBag()
    static var loginStuff = PublishSubject<String>()
        

    class func initialize() {
        print("In \(classForCoder()).initialize... RxSwift Resources: \(RxSwift.Resources.total)")
        client.allowSelfSignedSSL = true
        client.logLevel = .info
        setupObserver()
        connect()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(DDP_USER_DID_LOGIN), object: nil , queue: nil) { (notification: Notification) in
            if let username = Meteor.client.user() {
                loginStuff.onNext("In RVSwiftDDP.initialize DDP_USER_DID_LOGIN notification callback: \(username) and userId: \(client.userId() ?? "no userId")")
                //print("In RVSwiftDDP.initialize DDP_USER_DID_LOGIN notification callback, username \(username)")
            } else {
                print("In RVSwiftDDP.initialize DDP_USER_DID_LOGIN notifivcation callback, no username")
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(DDP_USER_DID_LOGOUT), object: nil, queue: nil) { (notification) in
            print("In RXSwiftDDP DDP_USER_DID_LOGOUT notification callback")
           // RVRouter.sharedInstance.newState(newState: RVAppState(state: .login))
            // RVViewDeck.sharedInstance.changeToLogin()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(DDP_WEBSOCKET_CLOSE), object: nil, queue: nil) { (notification) in
            print("In RXSwiftDDP DDP_WEBSOCKET_CLOSE notification callback")
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(DDP_WEBSOCKET_ERROR), object: nil, queue: nil) { (notification) in
            print("In RXSwiftDDP DDP_WEBSOCKET_ERROR notification callback")
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(DDP_DISCONNECTED), object: nil, queue: nil) { (notification) in
            print("In RXSwiftDDP DDP_DISCONNECTED notification callback")
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(DDP_FAILED), object: nil, queue: nil) { (notification) in
            print("In RXSwiftDDP DDP_FAILED notification callback")
        }
    }
    private class func setupObserver() {
        loginStuff.subscribe(
            onNext: {print("onNext: \($0)")},
            onError: { print("onError: \($0)")},
            onCompleted: { print("LoginOutPublisher Completed") },
            onDisposed: { print("LoginOutPublisher Disposed") }
            ).disposed(by: bag)
    }
    class func getId() -> String { return Meteor.client.getId() }
    
    class func connect() {
        let interval: TimeInterval = 4.0
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { (timer) in
            print("In RVDDP.connect, no newtork connection after \(interval) seconds")
        }
        super.connect(RVConfiguration.sharedInstance.baseServer) { 
            timer.invalidate()
            if let username = client.user() {
                 //loginStuff.onNext("Already Logged in with username: \(username) and userId: \(client.userId())")
                logout()
            } else {
                let username = "ttt@t.com"
                loginStuff.onNext("Logging with username: \(username)")
                Meteor.loginWithPassword(username, password: "password", callback: { (result, error) in
                    if let error = error {
                        loginStuff.onError(error)
                    } else if let payload = result as? [String: AnyObject] {
                        loginStuff.onNext("\(RVMeteorCredentials(payload: payload).toString())")
                    } else {
                        loginStuff.onNext("nothing)")
                    }
                })
            }
        }
        
    }
    

}
