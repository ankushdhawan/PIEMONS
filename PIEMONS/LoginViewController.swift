//
//  LoginViewController.swift
//  PIEMONS
//
//  Created by Ankush Dhawan on 3/17/22.
//

import UIKit
import Firebase
import ANLoader
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
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        view.endEditing(true)
        if formValidate(){
          viewModel.login(username: emailTextfield.text, password: passwordTextfield.text)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "navigateToSignUpScreen", sender: nil)
    }
    
}
extension LoginViewController:LoginResultProtocol {
    func success(user: User?) {
        ANLoader.hide()
        UserDefaultHelper.userToken = user?.refreshToken
        self.performSegue(withIdentifier: "openCameraScreen", sender: nil)
    }
    
    func error(error: Error) {
        ANLoader.hide()
        AlertUtility.showAlert(self, title: "Error", message: error.localizedDescription)
    }
}
