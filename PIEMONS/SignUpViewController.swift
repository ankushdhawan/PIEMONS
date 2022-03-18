//
//  SignUpViewController.swift
//  PIEMONS
//
//  Created by Ankush Dhawan on 3/17/22.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    var viewModel:SignUpViewModel!
    var handle:AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        viewModel = SignUpViewModel()
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
//        self.performSegue(withIdentifier: "navigateIntoCameraScreen", sender: nil)
        viewModel.SignUp(username: emailTextfield.text, password: passwordTextfield.text)

    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension SignUpViewController:SignUpResultProtocol {
    func success(user: User?) {
        
    }
    
    func error(error: Error) {
        
    }
   
}
