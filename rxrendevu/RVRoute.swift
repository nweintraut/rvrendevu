//
//  RVRoute.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/3/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation
class RVRoute {
    var priorRoute: RVRoute? = nil
    var routePaths = [RVRoutePath]()
    func appendPath(path: RVRoutePath) -> RVRoute {
        self.routePaths.append(path)
        return self
    }
    func getPath(level: Int) -> RVRoutePath? {
        if (level >= routePaths.count) || (level < 0) { return nil }
        return routePaths[level]
    }
    var pathDepth: Int { return routePaths.count }
    func clone() -> RVRoute {
        let route = RVRoute()
        for path in self.routePaths {_ = route.appendPath(path: path) }
        return route
    }
}
