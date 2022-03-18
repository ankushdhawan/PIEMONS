//
//  SignupViewModel.swift
//  PIEMONS
//
//  Created by Dhawan, Ankush on 17/03/22.
//

import Foundation
import Firebase
import FirebaseAuth
import ANLoader


protocol SignUpFunctionProtocol:AnyObject {
    
    func SignUp(username: String?, password: String?)
}

protocol SignUpResultProtocol: AnyObject {
    func success(user: User?)
    func error(error: Error)
}

class SignUpViewModel:SignUpFunctionProtocol {
    var user: User?
    var token: String?
    weak var delegate: SignUpResultProtocol?
    
    func SignUp(username: String?, password: String?) {
        /// It should have other validations here, if error, we will return error
         ANLoader.showLoading("Loading", disableUI: true)
        if let username = username, let password = password {
            print(username,password)
            Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
                if let user = authResult?.user {
                    print(user)
                    self.delegate?.success(user: user)
                } else {
                    self.delegate?.error(error: error!)
                }
            }
        } else {
            //delegate?.error(error: NSError(domain: "Value is nil", code: 1, userInfo:nil), type: type)
        }
    }
}
