//
//  ProjectController.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 14/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import UIKit
import JGProgressHUD

var issues: [Issue] = []
var responsibles: [Responsible] = []

class ProjectController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let contractNumberField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Contract number"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = .black
        return field
    }()
    
    private let addressField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Address"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = .black
        return field
    }()
    
    lazy var dateField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Date"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = .black
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        field.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        
        return field
    }()
    
    @objc func dateValueChanged(sender: UIDatePicker) {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .full
        dateFormat.timeStyle = .none
        self.dateField.text = dateFormat.string(from: sender.date)
    }
    
    private let responsiblesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Responsibles", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapResponsibles), for: .touchUpInside)
        return button
    }()
    
    private let issuesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Issues", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapIssues), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           
           scrollView.frame = view.bounds
           
           contractNumberField.frame = CGRect(x: 10,
                                     y: 20,
                                     width: scrollView.width - 20,
                                     height: 50)
           addressField.frame = CGRect(x: 10,
                                        y: contractNumberField.bottom + 10,
                                        width: scrollView.width - 20,
                                        height: 50)
        dateField.frame = CGRect(x: 10,
                                     y: addressField.bottom + 10,
                                     width: scrollView.width - 20,
                                     height: 50)
        responsiblesButton.frame = CGRect(x: 10,
                                             y: dateField.bottom + 10,
                                             width: scrollView.width - 20,
                                             height: 50)
        issuesButton.frame = CGRect(x: 10,
                                          y: responsiblesButton.bottom + 10,
                                          width: scrollView.width - 20,
                                          height: 50)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "New project"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        let vc = ProjectsTableViewController()
        
        //Delegates
        contractNumberField.delegate = self
        addressField.delegate = self
        dateField.delegate = self
        vc.projectSelectionDelegate = self

        // Adding SubViews
        view.addSubview(scrollView)
        scrollView.addSubview(contractNumberField)
        scrollView.addSubview(addressField)
        scrollView.addSubview(dateField)
        scrollView.addSubview(responsiblesButton)
        scrollView.addSubview(issuesButton)
    }
    
    @objc func didTapResponsibles() {
        let vc = ResponsiblesTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapIssues() {
        let vc = IssuesTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapSave() {
        
        guard let contractNumber = contractNumberField.text, let address = addressField.text, let date = dateField.text,
            !contractNumber.isEmpty, !address.isEmpty, !date.isEmpty else {
                AlertService.alertMsg(in: self, message: "Fill in all fields")
                return
        }
        
        spinner.show(in: view)
        
        let project = Project(contractNumber: contractNumber, address: address, date: date)
        FIRFirestoreService.shared.addProject(with: project) { (result) in
            print(result)
        }
        FIRFirestoreService.shared.addResponsibles(with: project, responsibles: responsibles) { (result) in
            print(result)
        }
        FIRFirestoreService.shared.addIssues(with: project, issueArray: issues)
        
        DispatchQueue.main.async {
            self.spinner.dismiss()
        }
        
        AlertService.alertMsg(in: self, message: "Project saved succesfully")
    }
}

extension ProjectController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == contractNumberField {
            addressField.becomeFirstResponder()
        } else if textField == addressField {
            dateField.becomeFirstResponder()
        }
        return true
    }
}

extension ProjectController: projectSelectionDelegate {
    
    func didTapOnProject(project: Project) {
        contractNumberField.text = project.contractNumber
        addressField.text = project.address
        dateField.text = project.date
    }
}
