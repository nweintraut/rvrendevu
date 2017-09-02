//
//  RVEJSON.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/1/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation
import SwiftDDP
class RVEJSON {
    class func convertToNSDate(ejson: NSDictionary) -> Date {
        return EJSON.convertToNSDate(ejson)
    }
    class func convertToEJSON(date: Date) -> [String: Double] {
        return EJSON.convertToEJSONDate(date)
    }
}
