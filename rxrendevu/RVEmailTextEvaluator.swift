//
//  RVEmailTextEvaluator.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/13/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation

class RVEmailTextEvaluator: NSObject {
    private let cannotContains = " " + "\r" + "\n" + ";" + ":" + "\\" + "/"
    func evaluate(text: String?, replacementRange: NSRange, replacementString: String) -> Bool {
        var text = text ?? ""
       // if !textClean(text: text) { return false }
       // if !textClean(text: replacementString) { return false }
        if replacementRange.length > 0 {
            // replacing any characters
            var prefix = ""
            if replacementRange.location > 0 {
                let prefixRange: Range<Int> = 0..<replacementRange.location
                prefix = text.substring(with: prefixRange)
            }
            var suffix = ""
            let suffixStart = replacementRange.location + replacementRange.length
            if suffixStart < text.characters.count {
                let suffixRange: Range<Int> = suffixStart..<text.characters.count
                suffix = text.substring(with: suffixRange)
            }
            text = prefix + suffix
        }
        text.insert(contentsOf: replacementString.characters, at: text.index(from: replacementRange.location))
       // print("In \(self.classForCoder), new text is \(text)")
        if !textClean(text: text) { return false }
        return true
    }
    func textClean(text: String?) -> Bool {
        if let text = text {
            if text.characters.count > 0 {
                for index in text.characters.indices {
                    let candidate = text[index]
                    if cannotContains.characters.contains(candidate) {
                        return false
                    }
                }
            }
        }
        return true
    }
}
class RVPasswordTextEvalutor: RVEmailTextEvaluator {
    
}
