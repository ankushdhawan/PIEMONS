//
//  LoginViewController.swift
//  PIEMONS
//
//  Created by Ankush Dhawan on 3/17/22.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextfield:UITextField!
    @IBOutlet weak var passwordTextfield:UITextField!
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var signUpButton:UIButton!
    var handle:AuthStateDidChangeListenerHandle?
    var viewModel:LoginViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
        viewModel.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        handle =    Auth.auth().addStateDidChangeListener { auth, user in
          // ...
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)

    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        viewModel.login(username: emailTextfield.text, password: passwordTextfield.text)
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "navigateToSignUpScreen", sender: nil)
    }
    
}
extension LoginViewController:LoginResultProtocol {
    func success(user: User?) {
        
    }
    
    func error(error: Error) {
        
    }
    
    
    
}
