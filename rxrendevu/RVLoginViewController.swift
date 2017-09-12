//
//  RVLoginViewController.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/3/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import RxSwift
import RxCocoa
import NSObject_Rx

class RVLoginViewController: RVBaseViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailMessageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordMessageLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        KeyboardAvoiding.avoidingView = loginView
        passwordTextField.delegate = self
        //emailTextField.delegate = self
        emailTextField.rx.setDelegate(self).disposed(by: rx_disposeBag)
        emailTextField.rx.textFieldDidBeginEditing.subscribe(onNext: { (alwaysTrue) in
            print("In textFieldDidBeginEditing)")
        }).disposed(by: rx_disposeBag)

        emailTextField.rx.textFieldDidEndEditing.subscribe(onNext: { (alwaysTrue) in
            print("In textFieldDidEndEditing)")
            }).disposed(by: rx_disposeBag)
        
        emailTextField.rx.textFieldDidEndEditingWithReason.subscribe(onNext: { (reason) in
            print("In textFieldDidEndEditingWithReason: \(reason.rawValue))")
        }).disposed(by: rx_disposeBag)
        
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
            print("In \(self.classForCoder).making passwordField first responders")
            self.passwordTextField.becomeFirstResponder()
        }

        else if textField == self.passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    func loginFailure(hide: Bool) {
        
    }
    func showHideEmailMessage(message: String, show: Bool) {
        
    }
    func showHidePasswordMessage(message: String, show: Bool) {
        
    }
    func hideButtons() {
    
    }
    func hideView(view: UIView?) {
        if let view = view { view.isHidden = true }
    }
    func showView(view: UIView?) {
        if let view = view { view.isHidden = false }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("In \(self.classForCoder).shouldChange, textFieldText: \(textField.text!) and newString is:\(string) \(string.characters.count)")
        self.loginFailure(hide: true)
        let emailField = (self.emailTextField != nil) && ( textField == self.emailTextField)
        let passwordField = (self.passwordTextField != nil) && (textField == self.passwordTextField)
        let text = textField.text ?? ""
        let count = text.characters.count
        let combined = "\(text)\(string)"
        if string == "" {
            // nothing new
            if count <= 1 {
                if emailField {
                    showHideEmailMessage(message: "Invalid Email", show: true)
                    hideButtons()
                    return true
                } else if passwordField {
                    showHidePasswordMessage(message: "Invalid Password", show: true)
                    hideButtons()
                } else {
                    return false
                }
            } else {
                let candidate = text.substring(to: count - 1)
                if emailField {
                    if let message = candidate.isValidEmail() {
                        showHideEmailMessage(message: message, show: true)
                        hideView(view: passwordView)
                        hideButtons()
                    } else {
                        
                    }
                }
            }
        } else {
            
        }
        return true
    }
 
    
}


/*
 override func viewDidLoad() {
 super.viewDidLoad()
 KeyboardAvoiding.avoidingView = loginView
 //  emailTextField.delegate = self
 
 /*      let goober = emailTextField.rx.controlEvent(UIControlEvents.allEvents).asObservable()
 .map { stuff in
 print("In map \(stuff)")
 return self.emailTextField.text!
 }
 .flatMap { text in
 return Observable.just(text)
 }
 .asDriver(onErrorJustReturn: "Error")
 goober.map{ goofy in  return self.emailTextField.text! }
 .drive(passwordTextField.rx.text)
 */
 
 passwordTextField.delegate = self
 emailTextField.delegate = self
 emailTextField.rx.text
 .filter {
 print("g \(String(describing: $0))")
 return ($0 ?? "").characters.count > 0
 }
 
 .flatMapLatest({ (text: String?) -> Observable<Any> in
 
 return Observable.empty()
 })
 .shareReplay(1)
 .observeOn(MainScheduler.instance)
 .subscribe(onNext: { data in
 
 }).disposed(by: rx_disposeBag)
 
 }
 */


