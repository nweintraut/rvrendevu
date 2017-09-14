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
    var programmatic: Bool
    
    init(storyboard: String, identifier: String, bundle: Bundle? = nil, programmatic: Bool = false) {
        self.storyboard = storyboard
        self.identifier = identifier
        self.bundle = bundle
        self.programmatic = programmatic
        super.init()
    }
    func match(candidate: RVControllerProfile) -> Bool {
        if self.identifier == candidate.identifier {
            if self.programmatic == candidate.programmatic {
                if self.storyboard == candidate.storyboard {
                    if (self.bundle != nil) && (candidate.bundle != nil) { return true }
                    else if (self.bundle == nil) && (candidate.bundle == nil) { return true }
                }
            }
        }
        return false
    }
    func toString() -> String {
        var output = "ControllerProfile: identifier: [\(self.identifier)], storyboard: [\(self.storyboard)]"
        let programmatic = self.programmatic ? "Programmatic" : "Not Programmatic"
        output = output + ", \(programmatic), \(self.bundle != nil ? "bundle is: \(self.bundle!)" : "no bundle")"
        return output
    }

}
