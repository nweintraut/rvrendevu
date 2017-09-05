//
//  RVMenuViewController.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift

class RVMenuViewController: RVBaseViewController {
    

    @IBOutlet weak var returnButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton(button: returnButton)
        
    }
    func setupMenuButton(button: UIBarButtonItem?) {
        if let button = button {
            button.rx.tap
                .throttle(0.3, scheduler: MainScheduler.instance)
                .subscribe(onNext: { _ in
                    //RVViewDeck.sharedInstance.toggleSide(side: .left)
                    _ = RVRouter.sharedInstance.startNewRoute(newRoute: RVRoute().appendPath(path: RVRoutePath(scene: .home, parameter: nil, model: nil)))
                })
                .disposed(by: rx_disposeBag)
        }
    }
}
