//
//  RVConfiguration.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/1/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit 
class RVConfiguration {
    static let sharedInstance: RVConfiguration = { return RVConfiguration() }()
    let baseServer: String = "wss://rnmpassword-nweintraut.c9users.io/websocket"
    let windowTintColor: UIColor = UIColor(red: 0.071, green: 0.42, blue: 0.694, alpha: 1.0)
}
