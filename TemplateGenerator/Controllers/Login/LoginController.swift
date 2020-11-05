//
//  LoginController.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 14/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
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
        field.isSecureTextEntry = true
        field.textColor = .black
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        emailField.frame = CGRect(x: 10,
                                  y: 20,
                                  width: scrollView.width - 20,
                                  height: 50)
        passwordField.frame = CGRect(x: 10,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 20,
                                     height: 50)
        loginButton.frame = CGRect(x: 10,
                                   y: passwordField.bottom + 10,
                                   width: scrollView.width - 20,
                                   height: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Login"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        //Delegates
        emailField.delegate = self
        passwordField.delegate = self

        // Adding SubViews
        view.addSubview(scrollView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
    }
    
    @objc func didTapLogin() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
            AlertService.alertMsg(in: self, message: "Email or password was incorrect")
            return
        }
        
        spinner.show(in: view)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
                
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
            guard let _ = authResult, error == nil else {
                    AlertService.alertMsg(in: self, message: "Error logging in")
                    return
                }
            UserDefaults.standard.set(email, forKey: "email")
            FIRFirestoreService.shared.setCompany(with: email)
            self.navigationController?.dismiss(animated: true, completion: nil)
            })
    }
    
    @objc func didTapRegister() {
        let vc = RegisterController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTapLogin()
        }
        return true
    }
}
