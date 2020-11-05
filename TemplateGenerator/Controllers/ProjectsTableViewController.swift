//
//  ProjectsTableViewController.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 14/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

protocol  projectSelectionDelegate {
    func didTapOnProject(project: Project)
}

class ProjectsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var projectSelectionDelegate: projectSelectionDelegate?
    
    private let spinner = JGProgressHUD(style: .dark)

    private var projects = [Project]()
    
    let vc = ProjectController()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Projects"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: #selector(didTapSignOut))
        tableView.dataSource = self
        tableView.delegate = self
        

        //Adding SubViews
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        validateAuth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        issues = []
        responsibles = []
    }

    private func validateAuth() {

        spinner.show(in: view)
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        } else {
            print("logged in")
            
            guard let currentEmail = FirebaseAuth.Auth.auth().currentUser?.email else {
                return
            }
            
            FIRFirestoreService.shared.setCompany(with: currentEmail)
            guard let company = UserDefaults.standard.string(forKey: "company"), !company.isEmpty else {
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                AlertService.alertMsg(in: self, message: "Couldn't get Your company's name")
                return
            }
            
                FIRFirestoreService.shared.getAllProjects(with: String(company)) { (projects) in
                    self.projects = projects
                    self.tableView.reloadData()
                    
                    DispatchQueue.main.async {
                        self.spinner.dismiss()
                    }
            }
            return
        }
    }
    
    @objc func didTapAdd() {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapSignOut() {
        
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        
        let vc = LoginController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = projects[indexPath.row].address
        cell.detailTextLabel?.text = "\(indexPath.row) project details"
        cell.imageView?.image = UIImage(systemName: "camera")
        cell.imageView?.tintColor = .link
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        projectSelectedDelegate.didTapOnProject(project: projects[2])
        do {
            print(try projects[indexPath.row].toJson())
            projectSelectionDelegate?.didTapOnProject(project: projects[indexPath.row])
            
            navigationController?.pushViewController(vc, animated: true)
            
        } catch {print(error)}
        
    }
}


