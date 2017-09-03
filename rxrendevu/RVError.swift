//
//  RVError.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/1/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation
import SwiftDDP

class RVError: Error {
    private var messages = [String]()
    //private var originalMessage: Error? = nil
    var error: String? = nil
    var details: String? = nil
    var reason: String? = nil
    var offendingMessage: String? = nil
    var sourceError: Error? = nil
    init(message: String, error: Error? = nil) {
        addMessage(message: message)
        //originalMessage = error
        
        self.sourceError = error
    }
    func addMessage(message: String) {
        messages.append(message)
    }
    func toString() -> String {
        var output = "Error:"
        for message in messages { output = output + "\n\(message)" }
        if let error = self.error { output = output + "\n\(error)" }
        if let details = self.details { output = output + "\n\(details)" }
        if let reason = self.reason { output = output + "\nReason: \(reason)"}
        if let offendingMessage = self.offendingMessage { output = output + "\nOffending Message: \(offendingMessage)"}
        return output
    }
}
extension RVError {
    class func convertDDPError(ddpError: DDPError?) -> RVError? {
        if let ddpError = ddpError {
            let rvError = RVError(message: "DDPError", error: ddpError)
            rvError.error = ddpError.error
            rvError.details = ddpError.details
            rvError.reason = ddpError.reason
            rvError.offendingMessage = ddpError.offendingMessage
            rvError.sourceError = ddpError
            return rvError
        } else {
            return nil
        }
    }
}
