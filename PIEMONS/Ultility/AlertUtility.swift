//
//  AlertUtility.swift
//  PIEMONS
//
//  Created by Ankush Dhawan on 3/18/22.
//

import Foundation
import UIKit
class CommonUtilities: NSObject{
    static let sharedInstance = CommonUtilities()
    
    struct EmailValidation {
        static func isValidEmail(email:String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: email)
        }
    }
}
class AlertUtility {
    static let CancelButtonIndex = -1;
    class func showAlert(_ onController:UIViewController, title:String?,message:String? ) {
        showAlert(onController, title: title, message: message, cancelButton: "OK", buttons: nil, actions: nil)
    }
    
    /**
     - parameter title:        title for the alert
     - parameter message:      message for alert
     - parameter cancelButton: title for cancel button
     - parameter buttons:      array of string for title for other buttons
     - parameter actions:      action is the callback which return the action and index of the button which was pressed
     */
    
    class func showAlert(_ onController:UIViewController?, title:String?,message:String? = nil ,cancelButton:String = "OK",buttons:[String]? = nil,actions:((_ alertAction:UIAlertAction,_ index:Int)->())? = nil) {
        // make sure it would be run on  main queue
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: cancelButton, style: UIAlertAction.Style.cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            actions?(action,CancelButtonIndex)
        }
        alertController.addAction(action)
        if let _buttons = buttons {
            for button in _buttons {
                let action = UIAlertAction(title: button, style: .default) { (action) in
                    let index = _buttons.index(of: action.title!)
                    actions?(action,index!)
                }
                alertController.addAction(action)
            }
        }
        if let onController = onController{
            onController.present(alertController, animated: true, completion: nil)
        }else{
            let appdel = UIApplication.shared.delegate as! AppDelegate
            appdel.window!.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
}

class Switcher: UIViewController {
    static func userLoggedIn() -> Bool{
        let token = UserDefaultHelper.userToken
        if token != nil{
            return true
        }
        return false
    }
    
    
}
