//
//  RVError.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/1/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation

class RVError: Error {
    private var messages = [String]()
    private var originalMessage: Error? = nil
    init(message: String, error: Error?) {
        addMessage(message: message)
        originalMessage = error
    }
    func addMessage(message: String) {
        messages.append(message)
    }
}
