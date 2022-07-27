import UIKit
import FirebaseAuth
import Firebase
import SnapKit

class SignUpVC: UIViewController, VCConfig {

    private let vstack = UIStackView()
    
    private let emailLabel = TextFieldLabel()
    private let emailTextField = Textfield()
    private let usernameLabel = TextFieldLabel()
    private let usernameTextField = Textfield()
    private let passwordLabel = TextFieldLabel()
    private let passwordTextField = Textfield()
    private let errorLabel = UILabel()
    private let signUpButton = Button()
    private let logInButton = Button()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign up"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .systemBackground
        
        configureComponents()
        configureLayout()
        
//        loginTapped(self)
    }
    
    func configureComponents(){
        
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.spacing = K.Spacing.sm
        
        emailLabel.setText("email")
        emailTextField.setText("Enter your email")
        emailTextField.addBottomBorder()

        usernameLabel.setText("username")
        usernameTextField.setText("Enter your username")
        usernameTextField.addBottomBorder()
        
        passwordLabel.setText("password")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.setText("Enter your password")
        passwordTextField.addBottomBorder()
        
        errorLabel.font = UIFont.systemFont(ofSize: K.FontSize.sm, weight: .medium)
        errorLabel.textColor = .red
        
        signUpButton.setTitle("Sign up", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)

        logInButton.setTitle("Log In", for: .normal)
        logInButton.invert()
        logInButton.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        
                
        vstack.addArrangedSubview(emailLabel)
        vstack.addArrangedSubview(emailTextField)
        vstack.addArrangedSubview(usernameLabel)
        vstack.addArrangedSubview(usernameTextField)
        vstack.addArrangedSubview(passwordLabel)
        vstack.addArrangedSubview(passwordTextField)
        vstack.addArrangedSubview(errorLabel)
        vstack.addArrangedSubview(signUpButton)
        vstack.addArrangedSubview(logInButton)
        vstack.addArrangedSubview(getEmptyView())
        
        vstack.translatesAutoresizingMaskIntoConstraints = false

        vstack.setCustomSpacing(K.Spacing.lg, after: emailTextField)
        vstack.setCustomSpacing(K.Spacing.lg, after: usernameTextField)
        vstack.setCustomSpacing(K.Spacing.lg, after: passwordTextField)
        vstack.setCustomSpacing(K.Spacing.md, after: errorLabel)
    }
    
    func configureLayout(){

        view.addSubview(vstack)

        logInButton.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        
        vstack.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(view)
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(K.Offset.md)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-K.Offset.md)
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
