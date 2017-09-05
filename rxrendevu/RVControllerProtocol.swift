//
//  RVControllerProtocol.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/4/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit

protocol RVControllerProtocol: class {
    var childControllerProfile: RVControllerProfile? { get set }
    var childController: UIViewController? { get set }
}
