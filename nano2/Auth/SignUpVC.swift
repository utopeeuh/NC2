import UIKit
import FirebaseAuth
import Firebase
import SnapKit

class SignUpVC: UIViewController, VCConfig {

    var emailTextField : Textfield!
    var usernameTextField : Textfield!
    var passwordTextField : Textfield!
    
    let signUpButton : UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 100, height: 50)
        button.backgroundColor = .red
        button.setTitle("Sign Up", for: .normal)
        
        return button
    }()
    
    let logInButton : UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 100, height: 50)
        button.backgroundColor = .green
        button.setTitle("Log In", for: .normal)
        
        return button
    }()

    let errorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9, weight: .medium)
        label.textColor = .red
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .white
        
        addComponents()
        configureLayout()
        configureComponents()
    }
    
    func addComponents() {
        emailTextField = Textfield()
        usernameTextField = Textfield()
        passwordTextField = Textfield()
        
        view.addSubview(emailTextField)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(logInButton)
        view.addSubview(errorLabel)
    }
    
    func configureLayout() {
        emailTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view).offset(K.Offset.topComponent)
            make.centerX.equalTo(view)
            make.width.equalTo(view).offset(-K.Offset.width)
        }

        setConstraints(usernameTextField, emailTextField, K.Offset.lg)
        setConstraints(passwordTextField, usernameTextField, K.Offset.lg)
        setConstraints(signUpButton, passwordTextField, K.Offset.lg)
        setConstraints(logInButton, signUpButton, K.Offset.md)
        setConstraints(errorLabel, logInButton, K.Offset.sm)
    }
    
    func configureComponents() {
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        
        emailTextField.setText("Enter your email")
        emailTextField.addBottomBorder()
        
        usernameTextField.setText("Enter your email")
        usernameTextField.addBottomBorder()

        passwordTextField.isSecureTextEntry = true
        passwordTextField.setText("Enter your password")
        passwordTextField.addBottomBorder()
    }
    
    func setConstraints(_ tf: ConstraintView, _ top: ConstraintView, _ offset: Int){
        tf.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(top.snp.bottom).offset(offset)
            make.centerX.equalTo(view)
            make.width.equalTo(view).offset(-40)
        }
    }

    func isPasswordValid(_ password : String) -> Bool {

        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }

    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message.
    func validationFields() -> String? {

        // Check that all fields are filled in
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in the entire form"
        }

        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isEmailValid(cleanedEmail) == false {
            return "The email address is badly formatted"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanedPassword) == false {
            return "The password must consists of at least 6 characters, including numbers and special characters"
        }
        
        return nil
    }
    
    @objc func signUpTapped(_ sender: UIButton) {
        //  Validate the fields
        errorLabel.text = ""
        let error = validationFields()

        if error != nil {
            //there's something wrong with the fields,show error message
            showError(error!)
        }else {

            // Create cleaned versions of the data
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            //  Create the user
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                //Check for errors
                if err != nil {
                    self.showError("Error dalam membuat akun")
                }

                else {
                    // User was created successfully, now store name & username

                    let userUid = result?.user.uid

                    let db = Firestore.firestore()

                    //firebaseUid and firestoreUid is equal
                    db.collection("users").document(userUid ?? "").setData(["username":username, "uid":result!.user.uid])
                    { error in
                        if error != nil {
                            //show error message
                            self.showError("Error dalam menyimpan data akun")
                        }
                    }

                    // Transition to the home screen
                    self.transitionToLogin()
                }
            }
        }
    }
    
    @objc func logInTapped(_ sender: UIButton){
        transitionToLogin()
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    func transitionToLogin() {
        if let navController = self.navigationController {
            navController.popViewController(animated: false)
        }
        
        let vc = scene.loginVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
