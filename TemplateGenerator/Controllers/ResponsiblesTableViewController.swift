//
//  ResponsiblesTableViewController.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 14/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import UIKit


class ResponsiblesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let pc = ProjectController()

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
       super.viewDidLoad()
        view.backgroundColor = .white
        title = "Responsibles"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //Adding SubViews
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
     @objc func didTapAdd() {

        AlertService.addResponsible(in: self) { (responsible) in
            responsibles.append(responsible)
            self.tableView.reloadData()
        }
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responsibles.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = responsibles[indexPath.row].name
           cell.imageView?.image = UIImage(systemName: "camera")
           cell.imageView?.tintColor = .link
           return cell
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AlertService.updateResponsible(in: self, Responsible: responsibles[indexPath.row]) { (newName) in
            responsibles[indexPath.row].name = newName
            self.tableView.reloadData()
        }
       }
}
