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
import Action

class RVLoginViewController: RVBaseViewController {
    var navigator = RVLoginNavigator()
    @IBOutlet weak var goofyView: UIView!
    @IBOutlet weak var emailMessageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var loginButtonView: UIView!
    @IBOutlet weak var registerButtonView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordMessageLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginRegisterErrorView: UIView!
    @IBOutlet weak var loginRegisterErrorLabel: UILabel!
    var viewModel = RVLoginViewModel()
    let passwordTextEvaluator   = RVPasswordTextEvalutor()
    let emailTextEvaluator      = RVEmailTextEvaluator()
    override func newRoute(level: Int, newRoute: RVRoute) -> Void {
       // print("IN \(self.classForCoder).RVBaseViewController.newRoute need to implement")
        self.navigator.newRoute(level: level, newRoute: newRoute)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.goofyView.layer.borderWidth = 5.0
        self.goofyView.layer.borderColor = UIColor.facebookBlue().cgColor
        self.hideView(view: self.emailMessageLabel)
        self.showHidePasswordStuff(hide: true)
        self.hideLoginRegisterButtonViews()
        KeyboardAvoiding.avoidingView = goofyView
        KeyboardAvoiding.padding = 20
        emailTextField.rx.setDelegate(self).disposed(by: rx_disposeBag)
        passwordTextField.rx.setDelegate(self).disposed(by: rx_disposeBag)
    
        let emailLookup = emailTextField.rx.text.orEmpty
            .filter {(input: String?) -> Bool in
                if let candidate = input {
                    if let message = candidate.isValidEmail() {
                        if self.emailTextField.isEditing {
                            self.showView(view: self.emailMessageLabel)
                            self.emailMessageLabel.text = message
                        }
                        self.showHidePasswordStuff(hide: true)
                        return false
                    } else {
                        self.hideView(view: self.emailMessageLabel)
                        self.showView(view: self.passwordTextField)
                        return true
                    }
                }
                else { return false }
            }
            .map { (input: String?) -> String in return (input != nil) ? input! : "" }
            .distinctUntilChanged()
            .throttle(2.0, scheduler: MainScheduler.instance)
            .flatMap { (email) -> Observable<String> in
            return RVMeteorService.sharedInstance.rx.findAccountViaEmail(email: email.lowercased())
                .catchErrorJustReturn("")
        }
        .shareReplay(1)
        .observeOn(MainScheduler.instance)

        
        Observable.combineLatest(emailTextField.rx.text, passwordTextField.rx.text, emailLookup) { (email, password, lookup) -> String in
            guard let email = email, let password = password else {
                return "hide"
            }
            if (email.isValidEmail() == nil) && (password.isValidPassword() == nil) {
                if lookup == "" { return "Register" }
                else { return "Login" }
            } else { return "hide" }
            }.subscribe(onNext: { (loginRegisterState) in
                if loginRegisterState == "Register" {
                    self.showLoginRegisterButtonView(login: false)
                    self.registerButton.isEnabled = true
                    self.loginButton.isEnabled = false
                } else if loginRegisterState == "Login" {
                    self.showLoginRegisterButtonView(login: true)
                    self.registerButton.isEnabled = false
                    self.loginButton.isEnabled = true
                } else {
                    self.enableButtons(enable: false)
                    self.hideLoginRegisterButtonViews()
                }
            }).disposed(by: rx_disposeBag)
        
        let passwordLookup = passwordTextField.rx.text
            .map { (input: String?) -> String in return (input != nil) ? input! : "" }
            .flatMap { (password) -> Observable<String> in
                return Observable<String>.just(password)
            }
            .shareReplay(1)
            .observeOn(MainScheduler.instance)
        passwordLookup.subscribe(onNext: { (password) in
            if let message = password.isValidPassword() {
                if self.passwordTextField.isEditing{
                    self.showView(view: self.passwordMessageLabel)
                    self.passwordMessageLabel.text = message
                }
            } else {
                self.hideView(view: self.passwordMessageLabel)
            }
        }, onError: { (error) in
            print(error)
        }).disposed(by: rx_disposeBag)
        
        
        let loginPasswordObservable = Observable.combineLatest(emailTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty) { (email, password) -> (String, String) in
            return (email, password)
        }
        let loginAction = viewModel.loginAction
        textButton.rx.tap.withLatestFrom(loginPasswordObservable)
        .subscribe(loginAction.inputs).disposed(by: rx_disposeBag)
        loginAction.elements.subscribe(onNext: { (result) in
            print("In elements have result \(result)")
        }, onError: { (error ) in
            if let error = error as? RVError {
                print(error.toString())
            }
        }).disposed(by: rx_disposeBag)
        /*
        viewModel.loginAction.elements.subscribe(onNext: { (result) in
            print("In\(self.classForCoder) action result \(result)")
        }, onError: { (error) in
            if let error = error as? RVError {
                print(error.toString())
            }
        }).disposed(by: rx_disposeBag)
*/
        loginButton.rx.tap.subscribe(onNext: {_ in
            if let email = self.emailTextField.text {
                if let password = self.passwordTextField.text {
                     RVMeteorService.sharedInstance.rx.loginViaPassword(email: email, password: password)
                    .subscribe(onNext: { (result) in
                        if let view = self.loginRegisterErrorView { view.isHidden = true }
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        print("Do Login Switch")
                    }, onError: { (error) in
                        if let error = error as? RVError {
                            self.showLoginRegisterError(message: "\(error.toString)")
                        }
                    }).disposed(by: self.rx_disposeBag)
                }
            }
        }).disposed(by: rx_disposeBag)
 
        registerButton.rx.tap.subscribe(onNext: {_ in
            print("In \(self.classForCoder).registerButton")
            if let email = self.emailTextField.text {
                if let password = self.passwordTextField.text {
                    RVMeteorService.sharedInstance.rx.register(email: email, password: password)
                        .subscribe(onNext: { (result) in
                            if let view = self.loginRegisterErrorView { view.isHidden = true }
                            print("Finished Register")
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            RVMeteorService.sharedInstance.rx.loginViaPassword(email: email, password: password)
                                .subscribe(onNext: { (result: Any?) in
                                
                            }, onError: { (error ) in
                                if let error = error as? RVError {
                                    print(error.toString())
                                }
                            } ).disposed(by: self.rx_disposeBag)
                        }, onError: { (error) in
                            if let error = error as? RVError {
                                self.showLoginRegisterError(message: "\(error.toString)")
                            }
                        }).disposed(by: self.rx_disposeBag)
                }
            }
        }).disposed(by: rx_disposeBag)
    }
    func showLoginRegisterError(message: String) {
        if let view = self.loginRegisterErrorView {
            if let label = self.loginRegisterErrorLabel {
                view.isHidden = false
                label.text = message
            }
        }
    }
    func enableButtons(enable: Bool) {
        if let login = self.loginButton { login.isEnabled = enable }
        if let register = self.registerButton { register.isEnabled = enable }
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

    func showHidePasswordStuff(hide: Bool) {
        self.showHideView(view: self.passwordTextField, hide: hide)
        if hide {self.showHideView(view: self.passwordMessageLabel, hide: hide) }
    }

}

extension RVLoginViewController: UITextFieldDelegate {

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField { self.passwordTextField.becomeFirstResponder() }
        else if textField == self.passwordTextField { textField.resignFirstResponder() }
        return true
    }
    

    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     //   print("In \(self.classForCoder).shouldChangeCharacters. String: [\(string)]")
        if (self.emailTextField != nil) && (self.emailTextField == textField) {
            return emailTextEvaluator.evaluate(text: textField.text, replacementRange: range, replacementString: string)
        } else if (self.passwordTextField != nil) && (self.passwordTextField == textField) {
            return passwordTextEvaluator.evaluate(text: textField.text, replacementRange: range, replacementString: string)
        }
        return false
    }
}
