//
//  RVLoginViewController.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/3/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
class RVLoginViewController: RVBaseViewController {
    override func viewWillDisappear(_ animated: Bool) {
        print("In \(self.classForCoder).viewWillDisappear \(Date().timeIntervalSince1970)")
        super.viewWillDisappear(animated)
    }
}
