//
//  RVLoginViewKeyboardAvoidingTextFieldProxy.swift
//  rxrendevu
//
//  Created by Neil Weintraut on 9/12/17.
//  Copyright © 2017 Neil Weintraut. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RVTextFieldProxy: DelegateProxy {


}

extension RVTextFieldProxy: DelegateProxyType {
    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        if let textField = object as? UITextField {
            textField.delegate = delegate as? UITextFieldDelegate
            /*
            if let delegate = delegate as? UITextFieldDelegate {
                print("In \(self.classForCoder()).setCurrentDelegate have delegate \(delegate)")
                textField.delegate = delegate
            } else {
                print("In \(self.classForCoder()).setCurrentDelegate, textField: \(textField), delegate \(delegate ?? "no-delegate" as AnyObject) is not a UITextFieldDelegate")
                print(delegate)
            }
 */
        } else {
            print("In \(self.classForCoder()).setCurrent Delegate, Object \(object) is nota UITextField")
        }
    }
    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        if let textView = object as? UITextField {
            return textView.delegate
        } else {
            print("In \(self.classForCoder()).currentDelegate, Object \(object) is not a UITextField")
            return nil
        }
    }
    
}

// Page 259 in RxSwift Book
extension Reactive where Base: UITextField {
    var delegate: DelegateProxy {
        return RVTextFieldProxy.proxyForObject(base)
    }
    public func setDelegate(_ delegate: UITextFieldDelegate) -> Disposable {
        return RVTextFieldProxy.installForwardDelegate(
            delegate,
            retainDelegate: false,
            onProxyForObject: self.base
        )
    }

    public var textFieldDidBeginEditing: ControlEvent<Bool> {
        let source = delegate
            .methodInvoked(#selector(UITextFieldDelegate.textFieldDidBeginEditing(_:)))
        .map { parameters -> Bool in
            return true
        }
        return ControlEvent(events: source)
    }

    public var textFieldDidEndEditing: ControlEvent<Bool> {
        let source = delegate
            .methodInvoked(#selector(UITextFieldDelegate.textFieldDidEndEditing(_:)))
            .map { parameters -> Bool in
                return true
        }
        return ControlEvent(events: source)
    }
    public var textFieldDidEndEditingWithReason: ControlEvent<UITextFieldDidEndEditingReason> {
        let source = delegate
            .methodInvoked(#selector(UITextFieldDelegate.textFieldDidEndEditing(_:reason:)))
            .map { parameters -> UITextFieldDidEndEditingReason in
                (parameters[1] as? UITextFieldDidEndEditingReason) ?? UITextFieldDidEndEditingReason.committed
        }
        return ControlEvent(events: source)
    }
}

extension RVTextFieldProxy: UITextFieldDelegate {

}
/*
 func textFieldDidBeginEditing(_ textField: UITextField) // became first responder
 func textFieldDidEndEditing(_ textField: UITextField) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) // if implemented, called in place of textFieldDidEndEditing:
 
 func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
 func textFieldShouldEndEditing(_ textField: UITextField) -> Bool // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
 func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool // return NO to not change text
 func textFieldShouldClear(_ textField: UITextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
 func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
 
 */
