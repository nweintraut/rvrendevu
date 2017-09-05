//
//  RVLoginViewController.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/3/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class RVLoginViewController: RVBaseViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailMessageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordMessageLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        KeyboardAvoiding.avoidingView = loginView
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}

extension RVLoginViewController: UITextFieldDelegate {
    // Optional
    // These delegate methods can be used so that test fields that are hidden by the keyboard are shown when they are focused
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            KeyboardAvoiding.avoidingView = self.loginView
        }

        else if textField == self.passwordTextField {
            KeyboardAvoiding.padding = 20
            KeyboardAvoiding.avoidingView = textField
            KeyboardAvoiding.padding = 0
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }

        else if textField == self.passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
