//
//  RVViewDeck.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/2/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import ViewDeck

enum RVViewDeckSide {
    case left
    case right
    case center
}
class RVViewDeck: RVNSObject {
    static let sharedInstance: RVViewDeck = { return RVViewDeck()} ()
    var deckController: IIViewDeckController = IIViewDeckController()
    var leftViewController: UIViewController? {
        get { return deckController.leftViewController }
        set { deckController.leftViewController = newValue }
    }
    var centerViewController: UIViewController {
        get { return deckController.centerViewController }
        set { deckController.centerViewController = newValue }
    }
    func initialize(appDelegate: AppDelegate) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window = window
        window.tintColor = RVConfiguration.sharedInstance.windowTintColor
        window.makeKeyAndVisible()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //UISearchBar.appearance().tintColor = UIColor.white
        //UISearchBar.appearance().barTintColor = UIColor.facebookBlue()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.facebookBlue()
        window.rootViewController = generateControllerStack()
    }
    func openSide(side: IIViewDeckSide, animated: Bool = true) { self.deckController.open(side, animated: animated) }
    func closeSide(animated: Bool = true) { self.deckController.closeSide(animated) }
    func toggleSide(side: RVViewDeckSide, animated: Bool = true) {
        // print("In \(self.classForCoder).toggleSide \(side)")
        let position: IIViewDeckSide = self.deckController.openSide
        if (position == IIViewDeckSide.none) {
            switch(side) {
            case .left:
                self.openSide(side: IIViewDeckSide.left, animated: animated)
            case .right:
                self.openSide(side: IIViewDeckSide.right, animated: animated)
            case .center:
                self.closeSide(animated: animated)
            }
        } else {
            self.closeSide()
        }
    }
    private func generateControllerStack() -> IIViewDeckController {
        var leftController = UIViewController()
        var centerController = UIViewController()
        
        if let controller = RVControllerFactory.sharedInstance.getController(key: .menu) {
            leftController = controller
        } else {
            print("In \(self.instanceType).generateControllerStack, failed to get LeftController")
        }
        if let controller = RVControllerFactory.sharedInstance.getController(key: .home) {
            centerController = controller
        } else {
            print("In \(self.instanceType).generateControllerStack, failed to get CenterController")
        }
        let deckController = IIViewDeckController(center: centerController, leftViewController: leftController)
        deckController.preferredContentSize = CGSize(width: 200, height: centerController.view.bounds.height)
        self.deckController = deckController
        deckController.delegate = self
        return deckController
    }
}
extension RVViewDeck: IIViewDeckControllerDelegate {
    
    
    /// @name Open and Close Sides
    
    /**
     Tells the delegate that the specified side will open.
     
     If this delegate method is not implemented, view deck will always open the side.
     
     @param viewDeckController The view deck controller informing the delegate.
     @param side               The side that will open. Either `IIViewDeckSideLeft` or `IIViewDeckSideRight`.
     
     @return `YES` if the View Deck Controller should open the side in question, `NO` otherwise.
     */
    func viewDeckController(_ viewDeckController: IIViewDeckController, willOpen side: IIViewDeckSide) -> Bool {
        //print("In \(self.classForCoder).willOpen side \(side)")
        return true
    }
    
    
    /**
     Tells the delegate that the specified side did open.
     
     @param viewDeckController The view deck controller informing the delegate.
     @param side               The side that did open. Either `IIViewDeckSideLeft` or `IIViewDeckSideRight`.
     */
    func viewDeckController(_ viewDeckController: IIViewDeckController, didOpen side: IIViewDeckSide) {
         print("In \(self.classForCoder).didOpen side \(side)")
    }
    
    
    /**
     Tells the delegate that the specified side will close.
     
     If this delegate method is not implemented, view deck will always close the side.
     
     @param viewDeckController The view deck controller informing the delegate.
     @param side               The side that will close. Either `IIViewDeckSideLeft` or `IIViewDeckSideRight`.
     
     @return `YES` if the View Deck Controller should close the side in question, `NO` otherwise.
     */
    func viewDeckController(_ viewDeckController: IIViewDeckController, willClose side: IIViewDeckSide) -> Bool {
        // print("In \(self.classForCoder).willClose side \(side)")
        return true
    }
    
    
    /**
     Tells the delegate that the specified side did close.
     
     If this delegate method is not implemented, view deck will always start panning.
     
     @param viewDeckController The view deck controller informing the delegate.
     @param side               The side that did close. Either `IIViewDeckSideLeft` or `IIViewDeckSideRight`.
     */
    func viewDeckController(_ viewDeckController: IIViewDeckController, didClose side: IIViewDeckSide) {
        print("In \(self.classForCoder).didClose side \(side)")
    }
    
    
    /// @name Interactive Transitions
    
    /**
     Asks the delegate whether panning (and therefore an interactive side change) should
     start or not.
     
     This method is only triggered if `-[IIViewDeckController isPanningEnabled]` returns
     `YES`.
     
     @param viewDeckController The view deck controller informing the delegate.
     @param side               The side that will open interactively.
     @return `YES` if view deck should start the interactive transition, `NO` if the
     transition should be cancelled.
     */
    func viewDeckController(_ viewDeckController: IIViewDeckController, shouldStartPanningTo side: IIViewDeckSide) -> Bool {
        //print("In \(self.classForCoder).showStartPanningTo side \(side)")
        return true
    }
}
