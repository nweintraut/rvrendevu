//
//  String+Extension.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/1/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation
extension String {
    func isValidEmail() -> String? {
        let email = self
        if email.contains(" ") { return "Email cannot contain spaces" }
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx, options: NSRegularExpression.Options.caseInsensitive)
            
            let match = regex.matches(in: email, options: NSRegularExpression.MatchingOptions.anchored, range: NSRange(location: 0, length: email.characters.count ) )
            if match.count == 0 { return "Not a valid email address :-(" }
            return nil
        } catch let error {
            return "In String Extension.validateEmail, got exception creating Regex \(error.localizedDescription)"
        }
    }
    func isValidPassword() -> String? {
        let minimumLength: Int = 5
        let password = self
        if password.characters.count < minimumLength { return "Password needs to be at least \(minimumLength) long " }
        if password.contains(" ") { return "Password cannot contain spaces" }
        return nil
    }
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return self.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
    
    public func stringByAddingPercentEncodingForFormData(plusForSpace: Bool=false) -> String? {
        let unreserved = "*-._"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        if plusForSpace {
            allowed.addCharacters(in: " ")
        }
        
        var encoded = self.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
        if plusForSpace {
            encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        }
        return encoded
    }
    public func trimLeadingAndTrailingSpaces() -> String {
        print("In StringExtension, need to correctly implement trimmming \(self)")
        return self
        // return ltrim().rtrim()
    }
    
    func rtrim() -> String {
        let whitespaceAndNewlineChars:[Character] = ["\n", "\r", "\t", " "]
        if isEmpty { return ""}
        var currentIndex = endIndex
        while currentIndex >= startIndex {
            currentIndex = self.index(before: currentIndex)
            let c = self[currentIndex]
            if whitespaceAndNewlineChars.contains(c) { break }
        }
        return self[startIndex...currentIndex]
    }
    
    func ltrim() -> String{
        let whitespaceAndNewlineChars:[Character] = ["\n", "\r", "\t", " "]
        if isEmpty{ return ""}
        var currentIndex = startIndex
        while currentIndex < endIndex {
            let c = self[currentIndex]
            if whitespaceAndNewlineChars.contains(c) { break }
            currentIndex = self.index(after: currentIndex)
        }
        return self[currentIndex..<endIndex]
    }
    func stripForFilename() -> String {
        var noSpaces = self.replacingOccurrences(of: " ", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: ":", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: ",", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: ";", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "-", with: "_")
        noSpaces = noSpaces.replacingOccurrences(of: "*", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "?", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "/", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "\\", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "$", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "!", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: ">", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "<", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "\n", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "\r|", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "\t", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "~", with: "")
        noSpaces = noSpaces.replacingOccurrences(of: "`", with: "")
        return noSpaces
    }
    
}
extension String {
    func padding(length: Int) -> String {
        return self.padding(toLength: length, withPad: " ", startingAt: 0)
    }
    
    func padding(length: Int, paddingString: String) -> String {
        return self.padding(toLength: length, withPad: " ", startingAt: 0)
    }
}
