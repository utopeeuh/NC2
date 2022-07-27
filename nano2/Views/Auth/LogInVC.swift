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
    
    private let vstack = UIStackView()
    
    private let emailLabel = TextFieldLabel()
    private let emailTextField = Textfield()
    private let passwordLabel = TextFieldLabel()
    private let passwordTextField = Textfield()
    private let errorLabel = UILabel()
    private let logInButton = Button()
    private let signUpButton = Button()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log in"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .systemBackground
        
        configureComponents()
        configureLayout()
        
        loginTapped(self)
    }
    
    func configureComponents(){
        
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.spacing = K.Spacing.sm
        
        emailLabel.setText("email")
        emailTextField.setText("Enter your email")
        emailTextField.addBottomBorder()

        passwordLabel.setText("password")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.setText("Enter your password")
        passwordTextField.addBottomBorder()
        
        errorLabel.font = UIFont.systemFont(ofSize: K.FontSize.sm, weight: .medium)
        errorLabel.textColor = .red
        
        logInButton.setTitle("Log In", for: .normal)
        logInButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.invert()
        signUpButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        
        vstack.addArrangedSubview(emailLabel)
        vstack.addArrangedSubview(emailTextField)
        vstack.addArrangedSubview(passwordLabel)
        vstack.addArrangedSubview(passwordTextField)
        vstack.addArrangedSubview(errorLabel)
        vstack.addArrangedSubview(logInButton)
        vstack.addArrangedSubview(signUpButton)
        vstack.addArrangedSubview(getEmptyView())
        
        vstack.translatesAutoresizingMaskIntoConstraints = false

        vstack.setCustomSpacing(K.Spacing.lg, after: emailTextField)
        vstack.setCustomSpacing(K.Spacing.lg, after: passwordTextField)
        vstack.setCustomSpacing(K.Spacing.md, after: errorLabel)
    }
    
    func configureLayout(){

        view.addSubview(vstack)
        vstack.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(view)
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(K.Offset.md)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-K.Offset.md)
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
                let vc = scene.tabBar
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
