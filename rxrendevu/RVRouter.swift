//
//  RVRouter.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/3/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation

class RVRouter {
    private var routes: [RVRoute] = [RVRoute]()
    static let sharedInstance: RVRouter = { return RVRouter() }()
    
    func pushRoute(route: RVRoute) {
        self.routes.insert(route, at: 0)
        if self.routes.count > 20 {
            self.routes.removeLast()
        }
    }
    func popRoute() -> RVRoute? {
        return self.routes.remove(at: 0)
    }
    func getTopRoute() -> RVRoute? {
        if routes.count > 0 { return routes[0] }
        return nil
    }
    func getRoute(level: Int) -> RVRoute? {
        if (level >= routes.count) || (level < 0) { return nil }
        return routes[level]
    }
    func emptyRoutes() {
        self.routes = [RVRoute]()
    }
    func startNewRoute(newRoute: RVRoute) -> Bool {
        return RVViewDeck.sharedInstance.startNewRoute(newRoute: newRoute)
    }
    func markEndOfRoute() {
        RVViewDeck.sharedInstance.newRouteInProcess = false
    }
}
