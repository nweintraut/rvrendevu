//
//  RVNSObject.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit

class RVNSObject: NSObject {
    var instanceType: String { get { return String(describing: type(of: self)) } }
}
