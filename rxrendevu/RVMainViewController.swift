//
//  RVMainViewController.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import NSObject_Rx

class RVMainViewController: RVBaseViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        
    }
    func setupMenuButton() {
        if let button = menuButton {
            button.rx.tap
            .subscribe(onNext: { _ in
                RVViewDeck.sharedInstance.toggleSide(side: .left)
            })
            .disposed(by: rx_disposeBag)
        }
    }
}
