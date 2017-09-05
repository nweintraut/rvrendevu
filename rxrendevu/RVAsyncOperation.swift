//
//  RVAsyncOperation.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/3/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation

typealias RVErrorCallback = (RVError?) -> Void
class RVAsyncOperation: Operation {
    fileprivate var callback: RVErrorCallback? = nil 
    let invoked     = Date()
    var ended: Date = Date()
    var error: RVError? = nil
    var title: String
    fileprivate var endedViaCancel: Bool = false
    fileprivate var _executing:     Bool = false
    fileprivate var _finished:      Bool = false
    init(title: String = "No Title") {
        self.title = title
    }
    init(title: String?, callback: @escaping RVErrorCallback) {
        self.title = title ?? "No title"
        self.callback = callback
    }
    override var isExecuting: Bool {
        get { return _executing }
        set {
            let key = "isExecuting"
            willChangeValue(forKey: key)
            _executing = newValue
            didChangeValue(forKey: key)
        }
    }
    override var isFinished: Bool {
        get { return _finished }
        set {
            let key = "isFinished"
            willChangeValue(forKey: key)
            _finished = newValue
            didChangeValue(forKey: key)
        }
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
            self.endViaCancel()
        } else {
            isExecuting = true
            asyncMain()
        }
    }
    /* This is to be overridden */
    func asyncMain() {
        print("In \(self.classForCoder).asyncMain base class, needs to be overridden")
        completeOperation()
    }
    override func main() {
        print("In \(self.classForCoder).main \(title) \(Date()). Should Not Be Here")
        completeOperation()
    }
    func endViaCancel() {
        self.endedViaCancel = true
        completeOperation()
    }
    func completeOperation() {
        DispatchQueue.main.async {
            self.ended = Date()
            print("Elapsed time for \(self.classForCoder) was: \( (self.ended.timeIntervalSince1970 - self.invoked.timeIntervalSince1970) )")
            self.isFinished = true
            self.isExecuting = false
            if let callback = self.callback {
                callback(self.error)
            } else {
                print("In \(self.classForCoder).completeOperation, no callback")
            }
        }
    }
}
