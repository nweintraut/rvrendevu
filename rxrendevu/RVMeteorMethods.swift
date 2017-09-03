//
//  RVMeteorMethods.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation

enum RVMeteorMethod: String {
    case getOrCreateUserProfile = "userprofiles.getorcreateuseruserprofile"
    case create = "create"
    case read = "read"
    case update = "update"
    case destroy = "destroy"
    case list = "list"
}
