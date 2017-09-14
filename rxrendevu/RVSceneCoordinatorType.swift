//
//  RVSceneCoordinatorType.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift

protocol RVSceneCoordinatorType {
    init(window: UIWindow)
    
    /// transition to another scene
    @discardableResult
    func transition(to scene: RVScene, routePath: RVRoutePath, type: RVSceneTransitionType) -> Observable<Void>
    
    /// pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Observable<Void>
}

extension RVSceneCoordinatorType {
    @discardableResult
    func pop() -> Observable<Void> {
        return pop(animated: true)
    }
}

