//
//  LogInViewController.swift
//  MC-2
//
//  Created by Stefanus Hermawan Sebastian on 07/06/22.
//

import UIKit
import FirebaseAuth
import SnapKit

class LogInVC: UIViewController, VCConfig{
    
    var emailTextField = Textfield()
    var passwordTextField = Textfield()
    let logInButton = UIButton()
    let signUpButton = UIButton()
    let errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .white
        
        configureComponents()
        configureLayout()
        
        loginTapped(self)
    }
    
    func configureComponents(){
        emailTextField.setText("Enter your email")
        emailTextField.addBottomBorder()

        passwordTextField.isSecureTextEntry = true
        passwordTextField.setText("Enter your password")
        passwordTextField.addBottomBorder()
        
        logInButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        logInButton.frame.size = CGSize(width: 100, height: 50)
        logInButton.backgroundColor = .red
        logInButton.setTitle("Log In", for: .normal)
        
        signUpButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        signUpButton.frame.size = CGSize(width: 100, height: 50)
        signUpButton.backgroundColor = .red
        signUpButton.setTitle("Sign Up", for: .normal)
        
        errorLabel.font = UIFont.systemFont(ofSize: 9, weight: .medium)
        errorLabel.textColor = .red
    }
    
    func configureLayout(){

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(logInButton)
        view.addSubview(signUpButton)
        view.addSubview(errorLabel)
        
        emailTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view).offset(K.Offset.topComponent)
            make.centerX.equalTo(view)
            make.width.equalTo(view).offset(-K.Offset.width)
        }
        
        setConstraints(passwordTextField, emailTextField,K.Offset.lg)
        setConstraints(logInButton, passwordTextField, K.Offset.lg)
        setConstraints(signUpButton, logInButton, K.Offset.md)
        setConstraints(errorLabel, signUpButton, K.Offset.sm)
    }
    
    func setConstraints(_ tf: ConstraintView, _ top: ConstraintView, _ offset: Int){
        tf.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(top.snp.bottom).offset(offset)
            make.centerX.equalTo(view)
            make.width.equalTo(view).offset(-K.Offset.width)
        }
    }
    
    @objc func loginTapped(_ sender: Any){
        //TODO : Validate text fields
        
        //Create cleaned versions of the text fields
//        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //login automatically
        let email = "adadad@a.com"
        let password = "asd!@#"
        
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                //Could not signin
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
                
            } else{
                print("Logged in")
                let vc = scene.homeVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func signupTapped(_ sender: Any){
        if let navController = self.navigationController {
            navController.popViewController(animated: false)
        }
        
        let vc = scene.signupVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
