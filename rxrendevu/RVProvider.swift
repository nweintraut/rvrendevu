//
//  RXProvider.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/1/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import Foundation

enum ProviderType {
    case email
    case google
    case facebook
    case twitter
}

class RVProvider: NSObject {
    var providerType: ProviderType
    private var _email: String = ""
    var email: String {
        get { return _email }
        set { _email = newValue.lowercased() }
    }
    var password: String = ""
    init(providerType: ProviderType) {
        self.providerType = providerType
    }
    class func email(email: String, password: String) -> (RVProvider, RVError?) {
        let provider = RVProvider(providerType: .email)
        var error: RVError? = nil
        if let report = RVProvider.validateEmail(email: email) {
            error = RVError(message: "In \(classForCoder()) Invalid email Report: \(report), email: [\(email)]", error: nil)
        }
        provider.email = email
        if let report = RVProvider.validatePassword(password: password) {
            let message = "In \(classForCoder()) invalid password. Report: \(report), password: [\(password)]"
            if let error = error {
                error.addMessage(message: message)
            } else {
                error = RVError(message: message, error: nil)
            }
        }
        provider.password = password
        return (provider, error)
    }
    class func validatePassword(password: String) -> String? {
        if password == "" { return "Password is empty" }
        print("In \(self.classForCoder()).validatePassword, need to implement")
        return nil
    }
    //http://swiftdeveloperblog.com/email-address-validation-in-swift/
    class func validateEmail(email: String) -> String?  {
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx, options: NSRegularExpression.Options.caseInsensitive)
            
            let match = regex.matches(in: email, options: NSRegularExpression.MatchingOptions.anchored, range: NSRange(location: 0, length: email.characters.count ) )
            if match.count == 0 { return nil }
            return "In \(classForCoder()).validateEmail, failed regex"
        } catch let error {
            return "In \(classForCoder()).validateEmail, got exception creating Regex \(error.localizedDescription)"
        }
    }
    
}
