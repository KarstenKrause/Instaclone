//
//  RegistrationViewController.swift
//  Instaclone
//
//  Created by Karsten Krause on 30.12.20.
//

import UIKit
import Firebase
import FirebaseAuth


class RegistrationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewComponents()
    }
    
    // MARK: - Methods
    func setupViewComponents() {
        setupUsernameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        addTargetToTextFields()
        setupInitialRegistrationButton()
    }

    func setupUsernameTextField() {
        usernameTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        usernameTextField.borderStyle = .roundedRect
    }
    
    func setupEmailTextField() {
        emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        emailTextField.borderStyle = .roundedRect
    }
    
    func setupPasswordTextField() {
        passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        passwordTextField.borderStyle = .roundedRect
    }
    
    func setupInitialRegistrationButton() {
        registrationButton.layer.cornerRadius = 5
        registrationButton.backgroundColor = UIColor(red: 0, green: 0.6, blue: 1.0, alpha: 0.4)
        registrationButton.setTitleColor(UIColor(white: 1.0, alpha: 0.4), for: .normal)
        registrationButton.isEnabled = false
    }
    
    func addTargetToTextFields() {
        usernameTextField.addTarget(self, action: #selector(textFieldChanged), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: UIControl.Event.editingChanged)
    }
    
    /// Checks that all three textfields have an input. If so, the registration button is enabled
    @objc func textFieldChanged() {
        let textInTextFields: Bool = usernameTextField.text?.count ?? 0 > 0 && emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if textInTextFields {
            registrationButton.layer.cornerRadius = 5
            registrationButton.backgroundColor = UIColor(red: 0, green: 0.6, blue: 1.0, alpha: 1)
            registrationButton.setTitleColor(UIColor(white: 1.0, alpha: 1), for: .normal)
            registrationButton.isEnabled = true
        } else {
            setupInitialRegistrationButton()
        }
    }
    
    // MARK: Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let newUser = data?.user else {return}
            let userId = newUser.uid
            
            self.uploadUserData(email: self.emailTextField.text!, userId: userId, username: self.usernameTextField.text!)
            
            print("User mit der Email \(String(describing: newUser.email)) erfolgreich erstellt")
        }
        
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Methods
    func uploadUserData(email: String, userId: String, username: String ) {
        let ref = Database.database().reference().child("users").child(userId)
        ref.setValue(["email" : email, "name": "", "profilImage_URL": "", "userDiscription": "", "userID" : userId, "username" : username ])
        
        self.performSegue(withIdentifier: "registrationSegue", sender: nil)
    }
    
}
