//
//  RVAsyncRouteOperation.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/3/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation
class RVAsyncRouteOperation: RVAsyncOperation {
    var newRoute: RVRoute
    init(title: String?, newRoute: RVRoute, callback: @escaping RVErrorCallback) {
        self.newRoute = newRoute
        super.init(title: title, callback: callback)
    }
    
    override func asyncMain() {
        doit()
    }
    func doit() {
        completeOperation()
    }
}
