//
//  LoginViewController.swift
//  Instaclone
//
//  Created by Karsten Krause on 30.12.20.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AuthenticationService.autoSignIn {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    // MARK: - Methods
    func setupViewComponents() {
        setupEmailTextField()
        setupPasswordTextField()
        addTargetToTextfields()
        setupInitialLoginButton()
    }
    
    func setupEmailTextField() {
        emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        emailTextField.borderStyle = .roundedRect
    }
    
    func setupPasswordTextField() {
        passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        passwordTextField.borderStyle = .roundedRect
    }
    
    func setupInitialLoginButton() {
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor(red: 0, green: 0.6, blue: 1.0, alpha: 0.5)
        loginButton.setTitleColor(UIColor(white: 1.0, alpha: 0.4), for: .normal)
        loginButton.isEnabled = false
    }
    
    func addTargetToTextfields() {
        emailTextField.addTarget(self, action: #selector(textFieldsChanged), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldsChanged), for: UIControl.Event.editingChanged)
    }
    
    /// Checks that both textfields have an input. If so, the login button is enabled
    @objc func textFieldsChanged() {
        let textInTextFields: Bool = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if textInTextFields {
            loginButton.layer.cornerRadius = 5
            loginButton.backgroundColor = UIColor(red: 0, green: 0.6, blue: 1.0, alpha: 1.0)
            loginButton.setTitleColor(UIColor(white: 1.0, alpha: 1.0), for: .normal)
            loginButton.isEnabled = true
        } else {
            setupInitialLoginButton()
        }
    }
    
    // MARK: Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        ProgressHUD.show()
        AuthenticationService.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!) {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        } onError: { (error) in
            ProgressHUD.showError("E-Mail oder Passwort ist falsch")
        }
    }
    
    

}
