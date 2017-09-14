//
//  RVNavigationType.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift

protocol RVBindableNavigationType {
  //  associatedtype ViewModelType
    var viewModel: RVBaseViewModel! {get set }
  //  var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

/*
extension RVBindableNavigationType where Self: UIViewController {
    mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
extension RVBindableNavigationType where Self: UINavigationController {
    mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

extension RVBindableNavigationType where Self: UITabBarController {
    mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
 */
