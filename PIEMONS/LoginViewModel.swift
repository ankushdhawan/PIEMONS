//
//  LoginViewModel.swift
//  LoginScreen
//
//  Created by Duy Bui - iOS App Templates on 10/29/19.
//  Copyright © 2019 Duy Bui - iOS App Templates. All rights reserved.
//

import Foundation
import Firebase

protocol LoginFunctionProtocol {
  
  func login(username: String?, password: String?)
}

protocol LoginResultProtocol: class {
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
          //delegate?.success(user: user, type: type)

          // ...
        }
    } else {
      //delegate?.error(error: NSError(domain: "Value is nil", code: 1, userInfo:nil), type: type)
    }
  }
}
