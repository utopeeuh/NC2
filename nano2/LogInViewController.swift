//
//  LogInViewController.swift
//  MC-2
//
//  Created by Stefanus Hermawan Sebastian on 07/06/22.
//

import UIKit
import FirebaseAuth
import SnapKit

class LogInViewController: UIViewController {
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your e-mail"
        return tf
    }()

    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let logInButton : UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 100, height: 50)
        button.backgroundColor = .red
        button.setTitle("Log In", for: .normal)
        
        return button
    }()
    
    let errorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9, weight: .medium)
        label.textColor = .red
        return label
    }()
    
//    @IBOutlet weak var buatAkunButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(logInButton)
        view.addSubview(errorLabel)
        
        logInButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        configure()
    }
    
    func configure(){

        emailTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view).offset(100)
            make.centerX.equalTo(view)
            make.width.equalTo(view).offset(-40)
        }
        
        setConstraints(passwordTextField, emailTextField, 15)
        setConstraints(logInButton, passwordTextField, 15)
        setConstraints(errorLabel, logInButton, 15)
    }
    
    func setConstraints(_ tf: ConstraintView, _ top: ConstraintView, _ offset: Int){
        tf.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(top.snp.bottom).offset(offset)
            make.centerX.equalTo(view)
            make.width.equalTo(view).offset(-40)
        }
    }
    
    @objc func loginTapped(_ sender: Any){
        //TODO : Validate text fields
        
        //Create cleaned versions of the text fields
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                //Could not signin
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else{

                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? ViewController
                    
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
//    @IBAction func buatAkunTapped(_ sender: Any){
////        self.performSegue(withIdentifier: "gotosignup", sender: self)
//    }

}
