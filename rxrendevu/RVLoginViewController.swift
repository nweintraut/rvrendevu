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
    let passwordTextEvaluator = RVPasswordTextEvalutor()
    let emailTextEvaluator = RVEmailTextEvaluator()

    override func viewDidLoad() {
        super.viewDidLoad()
        KeyboardAvoiding.avoidingView = loginView
        emailTextField.rx.setDelegate(self).disposed(by: rx_disposeBag)
        passwordTextField.rx.setDelegate(self).disposed(by: rx_disposeBag)
        
        emailTextField.rx.textFieldDidBeginEditing.subscribe(onNext: { (alwaysTrue) in
            print("In textFieldDidBeginEditing)")
        }).disposed(by: rx_disposeBag)

        emailTextField.rx.textFieldDidEndEditing.subscribe(onNext: { (alwaysTrue) in
            print("In textFieldDidEndEditing)")
            }).disposed(by: rx_disposeBag)
        
        emailTextField.rx.textFieldDidEndEditingWithReason.subscribe(onNext: { (reason) in
            print("In textFieldDidEndEditingWithReason: \(reason.rawValue))")
        }).disposed(by: rx_disposeBag)
        
        let emailInput = emailTextField.rx.text
            .filter { (input: String?) -> Bool in
          //      print("In \(self.classForCoder)emailTextField.rx.text: \(String(describing: input))")
                return (input ?? "").characters.count > 0
            }
            .flatMap({ (text: String?) -> Observable<String> in
                return Observable<String>.just(text!)
            })
        emailInput  .subscribe(onNext: { (e: String) in
            print("In \(self.classForCoder).emailInput.subscribe: \(e)")
        }).disposed(by: rx_disposeBag)
        
        
        let emailInput2 = emailTextField.rx.text
            .filter{(input: String?) -> Bool in
                if let text = input {
                   return (text.isValidEmail() == nil)
                } else { return false }
        }
            .flatMapLatest { (text: String?) -> Observable<String> in
            return Observable<String>.just(text!)
        }
        .shareReplay(1)
        .observeOn(MainScheduler.instance)
        emailInput2.subscribe(onNext: { (email: String) in
            RVMeteorService.sharedInstance.rxFindAccountViaEmail(email: email)
                .subscribe(onNext: { (email: String) in
                print("email is: \(email)")
            }, onError: { (error ) in
                print(error)
                }, onCompleted: {
                    print("COmpleted")
                }, onDisposed: {
                    print("Disposed")
                }).disposed(by: self.rx_disposeBag)
        }).disposed(by: rx_disposeBag)
 
    }

}

extension RVLoginViewController: UITextFieldDelegate {
    // Optional
    // These delegate methods can be used so that test fields that are hidden by the keyboard are shown when they are focused
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            KeyboardAvoiding.padding = 20
            KeyboardAvoiding.avoidingView = textField
        }

        else if textField == self.passwordTextField {
            KeyboardAvoiding.padding = 20
            KeyboardAvoiding.avoidingView = self.loginView
            KeyboardAvoiding.padding = 0
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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


