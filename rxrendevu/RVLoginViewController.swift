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
    
    @IBOutlet weak var goofyView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailMessageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var loginButtonView: UIView!
    @IBOutlet weak var registerButtonView: UIView!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordMessageLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let passwordTextEvaluator = RVPasswordTextEvalutor()
    let emailTextEvaluator = RVEmailTextEvaluator()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.goofyView.layer.borderWidth = 5.0
        self.goofyView.layer.borderColor = UIColor.facebookBlue().cgColor
        self.hideView(view: self.emailMessageLabel)
        self.hideView(view: self.passwordView)
        self.hideView(view: self.passwordMessageLabel)
        self.hideLoginRegisterButtonViews()
        KeyboardAvoiding.avoidingView = loginView
        emailTextField.rx.setDelegate(self).disposed(by: rx_disposeBag)
     //   passwordTextField.delegate = self
        passwordTextField.rx.setDelegate(self).disposed(by: rx_disposeBag)
        
        emailTextField.rx.textFieldDidBeginEditing.subscribe(onNext: { (alwaysTrue) in
            print("In email rx.textFieldDidBeginEditing")
        }).disposed(by: rx_disposeBag)

        emailTextField.rx.textFieldDidEndEditing.subscribe(onNext: { (alwaysTrue) in
            print("In email rx.textFieldDidEndEditing)")
            }).disposed(by: rx_disposeBag)
        
        passwordTextField.rx.textFieldDidBeginEditing.subscribe(onNext: { (alwaysTrue) in
            print("In password rx.textFieldDidBeginEditing")
        }).disposed(by: rx_disposeBag)
        
        passwordTextField.rx.textFieldDidEndEditing.subscribe(onNext: { (alwaysTrue) in
            print("In password rx.textFieldDidEndEditing)")
        }).disposed(by: rx_disposeBag)
        /*
        emailTextField.rx.textFieldDidEndEditingWithReason.subscribe(onNext: { (reason) in
            print("In textFieldDidEndEditingWithReason: \(reason.rawValue))")
        }).disposed(by: rx_disposeBag)
        */

        
        let emailLookup = emailTextField.rx.text
            .filter {(input: String?) -> Bool in
                self.hideView(view: self.passwordView)
                if let candidate = input {
                    if let message = candidate.isValidEmail() {
                        self.hideLoginRegisterButtonViews()
                        self.showView(view: self.emailMessageLabel)
                        self.emailMessageLabel.text = message
                        return false
                    } else {
                        self.hideView(view: self.emailMessageLabel)
                        self.showView(view: self.passwordView)
                        return true
                    }
                }
                else { return false }
            }
            .map { (input: String?) -> String in return (input != nil) ? input! : "" }
            .distinctUntilChanged()
            .throttle(3.0, scheduler: MainScheduler.instance)
            .flatMap { (email) -> Observable<String> in
            return RVMeteorService.sharedInstance.rx.findAccountViaEmail(email: email.lowercased())
                .catchErrorJustReturn("")
        }
        .shareReplay(1)
        .observeOn(MainScheduler.instance)
        emailLookup.subscribe(onNext: { (email) in
            print("In emailLookup with: \(email)")
            if email != "" {
               self.showLoginRegisterButtonView(login: true)
            } else {
               self.showLoginRegisterButtonView(login: false)
            }
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("In emailLookup on Completed")
        }).disposed(by: rx_disposeBag)
        
        
        /*
        let passwordLookup = passwordTextField.rx.text
            .filter {(input: String?) -> Bool in
               // self.hideView(view: self.passwordView)
                if let candidate = input {
                    if let message = candidate.isValidPassword() {
                  //      self.hideLoginRegisterButtonViews()
                  //      self.showView(view: self.emailMessageLabel)
                 //       self.emailMessageLabel.text = message
                        return false
                    } else {
                  //      self.hideView(view: self.emailMessageLabel)
                  //      self.showView(view: self.passwordView)
                        return true
                    }
                }
                else { return false }
            }
            .map { (input: String?) -> String in return (input != nil) ? input! : "" }
            .throttle(3.0, scheduler: MainScheduler.instance)
            .flatMap { (email) -> Observable<String> in
                return Observable<String>.just("Password")
            }
            .shareReplay(1)
            .observeOn(MainScheduler.instance)
        passwordLookup.subscribe(onNext: { (password) in
            print("In passwordLookup with: \(password)")
            if password != "" {
               // self.showLoginRegisterButtonView(login: true)
            } else {
              //  self.showLoginRegisterButtonView(login: false)
            }
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("In passwordLookup on Completed")
        }).disposed(by: rx_disposeBag)
        
        */
    }
    
    func showLoginRegisterButtonView(login: Bool) {
        if let loginView = self.loginButtonView {
            loginView.isHidden = !login
        }
        if let registerView = self.registerButtonView {
            registerView.isHidden = login
        }
    }
    func hideLoginRegisterButtonViews() {
        self.hideView(view: self.loginButtonView)
        self.hideView(view: self.registerButtonView)
    }
    func emailOrPassword(textField: UITextField) -> String {
  
        if (textField == self.emailTextField) { return "Email" }
        return "Password"
    }

}

extension RVLoginViewController: UITextFieldDelegate {
    // Optional
    // These delegate methods can be used so that test fields that are hidden by the keyboard are shown when they are focused
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("IN \(self.classForCoder).textFieldShouldBeginEditing \(self.emailOrPassword(textField: textField))")
        if textField == self.emailTextField {
            KeyboardAvoiding.padding = 20
            KeyboardAvoiding.avoidingView = self.goofyView
            //KeyboardAvoiding.padding = 300
        }

        else if textField == self.passwordTextField {
                        KeyboardAvoiding.padding = 200
            KeyboardAvoiding.avoidingView = self.passwordView
          //  self.showView(view: self.passwordView)

      //      KeyboardAvoiding.avoidingView = textField
          //  KeyboardAvoiding.padding = 0
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("In \(self.classForCoder).textFieldShouldEndEditing \(self.emailOrPassword(textField: textField))")
     //   if textField == self.emailTextField { self.passwordTextField.becomeFirstResponder() }
     //   else if textField == self.passwordTextField { textField.resignFirstResponder() }
//        if textField == self.passwordTextField { return false }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("In \(self.classForCoder).textFieldShouldReturn \(self.emailOrPassword(textField: textField))")
        if textField == self.emailTextField { self.passwordTextField.becomeFirstResponder() }
        else if textField == self.passwordTextField { textField.resignFirstResponder() }
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

    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("In \(self.classForCoder).shouldChangeCharacters. String: [\(string)]")
        if (self.emailTextField != nil) && (self.emailTextField == textField) {
            return emailTextEvaluator.evaluate(text: textField.text, replacementRange: range, replacementString: string)
        } else if (self.passwordTextField != nil) && (self.passwordTextField == textField) {
            return passwordTextEvaluator.evaluate(text: textField.text, replacementRange: range, replacementString: string)
        }
        return false
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


