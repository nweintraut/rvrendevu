//
//  RVScene.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//


import UIKit

enum RVScene {
    case tasks(String)
    case editTask(String)
}
extension RVScene {
    func viewController(navigationPath: RVRoutePath) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .tasks(let viewModel):
            print(viewModel)
            let nc = storyboard.instantiateViewController(withIdentifier: "Tasks") as! UINavigationController
            if var nc = nc as? RVNavigationType {
                nc.navigationPath = navigationPath
            }
//            var vc = nc.viewControllers.first as! UIViewController
//            vc.bindViewModel(to: viewModel)
            return nc
            
        case .editTask(let viewModel):
            print(viewModel)
            let nc = storyboard.instantiateViewController(withIdentifier: "EditTask") as! UINavigationController
//            var vc = nc.viewControllers.first // as! EditTaskViewController
//            vc.bindViewModel(to: viewModel)
            return nc
        }
    }
}
