//
//  RVMainViewController.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import NSObject_Rx
import RxSwift

class RVMainViewController: RVBaseViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {

         print("In \(self.classForCoder).viewDidLoad \(Date().timeIntervalSince1970)")
        super.viewDidLoad()
        setupMenuButton()
        
    }
    func setupMenuButton() {
        if let button = menuButton {
            button.rx.tap
                .throttle(0.3, scheduler: MainScheduler.instance)
                .subscribe(onNext: { _ in
                    let _ = RVViewDeck.sharedInstance.startNewRoute(newRoute: RVRoute().appendPath(path: RVRoutePath(scene: .menu, parameter: nil, model: nil)))
                })
                .disposed(by: rx_disposeBag)
        }
    }
}
