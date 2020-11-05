//
//  RegisterController.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 14/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterController: UIViewController {

    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = .black
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = .black
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = .black
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = .black
        field.isSecureTextEntry = true
        return field
    }()
    
    private let companyField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Company name ALL CAPS"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = .black
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           
           scrollView.frame = view.bounds
           
        nameField.frame = CGRect(x: 10,
                                  y: 20,
                                  width: scrollView.width - 20,
                                  height: 50)
        lastNameField.frame = CGRect(x: 10,
                                  y: nameField.bottom + 10,
                                  width: scrollView.width - 20,
                                  height: 50)
           emailField.frame = CGRect(x: 10,
                                     y: lastNameField.bottom + 10,
                                     width: scrollView.width - 20,
                                     height: 50)
           passwordField.frame = CGRect(x: 10,
                                        y: emailField.bottom + 10,
                                        width: scrollView.width - 20,
                                        height: 50)
        companyField.frame = CGRect(x: 10,
                                     y: passwordField.bottom + 10,
                                     width: scrollView.width - 20,
                                     height: 50)
           registerButton.frame = CGRect(x: 10,
                                      y: companyField.bottom + 10,
                                      width: scrollView.width - 20,
                                      height: 50)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Register"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //Delegates
        emailField.delegate = self
        passwordField.delegate = self

        // Adding SubViews
        view.addSubview(scrollView)
        scrollView.addSubview(nameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(companyField)
        scrollView.addSubview(registerButton)
    }
    
    @objc func didTapRegister() {
        
        nameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        companyField.resignFirstResponder()
            
        spinner.show(in: view)
        
        guard let name = nameField.text, let lastName = lastNameField.text, let email = emailField.text, let password = passwordField.text,
            let company = companyField.text?.uppercased(), !name.isEmpty, !lastName.isEmpty,!email.isEmpty, !password.isEmpty, !company.isEmptyOrWhitespace()
            else {
            AlertService.alertMsg(in: self, message: "Register data is incorrect")
                
            return
        }
        
        let user = User(name: name, lastName: lastName, email: email, company: company)

        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion:  { authResult, error in
            guard let result = authResult, error == nil else {
                AlertService.alertMsg(in: self, message: "User already exists")
                return
            }
            
            FIRFirestoreService.shared.insertUser(with: user)
            UserDefaults.standard.set(email, forKey: "email")
            FIRFirestoreService.shared.setCompany(with: email)
            
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
            let vc = ProjectsTableViewController()
            let user = result.user
            print("Created user \(user)")
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }

}

extension RegisterController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            companyField.becomeFirstResponder()
        } else if textField == companyField {
            didTapRegister()
        }
        return true
    }
}

extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
