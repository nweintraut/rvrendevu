//
//  RVSceneCoordinator.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/14/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift

class RVSceneCoordinator: RVSceneCoordinatorType {
    fileprivate var window: UIWindow
    fileprivate var currentViewController: UIViewController
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return viewController
        }
    }
    
    /// transition to another scene
    @discardableResult
    func transition(to scene: RVScene, routePath: RVRoutePath, type: RVSceneTransitionType) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController(navigationPath: routePath)
        switch type {
        case .root:
            self.currentViewController = RVSceneCoordinator.actualViewController(for: viewController)
            window.rootViewController = viewController
            subject.onCompleted()
        case .push:
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller wihtout a current navigation controller")
            }
            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map{ _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: true)
            currentViewController = RVSceneCoordinator.actualViewController(for: viewController)
        case .modal:
            currentViewController.present(viewController, animated: true, completion: {
                subject.onCompleted()
            })
            currentViewController = RVSceneCoordinator.actualViewController(for: viewController)
        }
        return subject.asObservable().take(1).ignoreElements()
    }
    
    /// pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        if let presenter = currentViewController.presentingViewController {
            // dismiss a model controller
            currentViewController.dismiss(animated: animated, completion: {
                self.currentViewController = RVSceneCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            })
        } else if let navigationController = currentViewController.navigationController {
            // navigate up the stack
            // one-off subscription to be notified when pop completes
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map{ _ in }
                .bind(to: subject)
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("Can't navigate back from \(currentViewController)")
            }
            currentViewController = RVSceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
        return subject.asObservable().take(1).ignoreElements()
    }
}
