//
//  RVBaseModel.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit

class RVBaseModel: NSObject {
    private var objects = [String: AnyObject]()
    
    
    init(fields: [String: AnyObject]) {
        self.objects = fields
    }
}
