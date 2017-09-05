//
//  RVOperationQueue.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/3/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation
class RVOperationQueue: OperationQueue {
    private var maxSize: Int = 20
    var title: String = "RVOperationQueue"
    init(title: String, maxSize: Int = 20) {
        super.init()
        self.title = title
        self.maxSize = maxSize
        self.maxConcurrentOperationCount = 1
    }
    override func addOperation(_ op: Operation) {
        var title = "no title"
        if let operation = op as? RVAsyncOperation {
            title = operation.title
        }
        if self.operationCount < maxSize {
            super.addOperation(op)
        } else {
            print("In \(self.title).addOperation \(title). Count exceeds \(maxSize); ignoring")
        }
    }
}
