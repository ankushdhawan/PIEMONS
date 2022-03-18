//
//  LoginViewModel.swift
//  LoginScreen
//
//  Created by Duy Bui - iOS App Templates on 10/29/19.
//  Copyright © 2019 Duy Bui - iOS App Templates. All rights reserved.
//

import Foundation
import Firebase
import ANLoader

protocol LoginFunctionProtocol:AnyObject {
  
  func login(username: String?, password: String?)
}

protocol LoginResultProtocol: AnyObject {
  func success(user: User?)
  func error(error: Error)
}

class LoginViewModel:LoginFunctionProtocol {
  var user: User?
  var token: String?
  weak var delegate: LoginResultProtocol?
  
  func login(username: String?, password: String?) {
    /// It should have other validations here, if error, we will return error
    if let username = username, let password = password {
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if let user = authResult?.user {
                print(user)
                self?.delegate?.success(user: user)
            } else {
                self?.delegate?.error(error: error!)
            }
        }
    } else {
        
      //delegate?.error(error: NSError(domain: "Value is nil", code: 1, userInfo:nil), type: type)
    }
  }
}
