//
//  RVMeteorCredentials.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/1/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation
import SwiftDDP
class RVMeteorCredentials {
    var payload = [String : AnyObject]()
    init(payload: [String : AnyObject]) {
        self.payload = payload
    }
    var id: String? {
        get {
            if let id = payload["id"] as? String { return id }
            return nil
        }
    }
    var token: String? {
        get {
            if let token = payload["token"] as? String { return token }
            return nil
        }
    }
    var tokenExpiration: Date? {
        get {
            if let ejson = payload["tokenExpires"] as? NSDictionary {
                return RVEJSON.convertToNSDate(ejson: ejson)
            } else {
                return nil
            }
        }
    }
    func toString() -> String {
        var output = "Credentials: {"
        output = output + " id=[\((self.id ?? "none"))], "
        output = output + " token=\( (self.token ?? " none"))],"
        output = output + " expires=\( (self.tokenExpiration?.description ?? "no date"))]}"
        return output
        
    }
}
