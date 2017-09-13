//
//  UIViewController+Extensions.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/3/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
extension UIViewController {
    func hideView(view: UIView?) { if let view = view { view.isHidden = true } }
    func showView(view: UIView?) { if let view = view { view.isHidden = false } }
    func showHideView(view: UIView?, hide: Bool) { if let view = view { view.isHidden = hide } }
}
