//
//  RVControllerProfile.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit

class RVControllerProfile: RVNSObject {
    var storyboard: String
    var identifier: String
    var bundle: Bundle?
    
    init(storyboard: String, identifier: String, bundle: Bundle? = nil) {
        self.storyboard = storyboard
        self.identifier = identifier
        self.bundle = bundle
        super.init()
    }
    func match(candidate: RVControllerProfile) -> Bool {
        if self.identifier == candidate.identifier {
            if self.storyboard == self.storyboard {
                return true
            }
        }
        return false
    }

}
