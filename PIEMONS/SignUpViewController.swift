//
//  SignUpViewController.swift
//  PIEMONS
//
//  Created by Ankush Dhawan on 3/17/22.
//

import UIKit
import Firebase
import ANLoader


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
    
    fileprivate func formValidate() ->Bool {
        var message:String?
         if CommonUtilities.EmailValidation.isValidEmail(email: emailTextfield.text!) == false{
            message = "Please enter valid email."
        }else if (passwordTextfield.text?.trimSpace().isEmpty)!{
            message = "Please enter  password"
        }else{
            return true
        }
        if message != nil{
            AlertUtility.showAlert(self, title: message)
        }
        return false
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        view.endEditing(true)
//        self.performSegue(withIdentifier: "navigateIntoCameraScreen", sender: nil)
        if formValidate(){
            viewModel.SignUp(username: emailTextfield.text, password: passwordTextfield.text)
        }

    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension SignUpViewController:SignUpResultProtocol {
    func success(user: User?) {
         ANLoader.hide()
        AlertUtility.showAlert(self, title: "Congratulation,your account has been successfully created.", cancelButton: "OK", buttons: nil, actions: { (alertAction, index) in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func error(error: Error) {
        ANLoader.hide()
        AlertUtility.showAlert(self, title: "Error", message: error.localizedDescription)
    }
   
}
