//
//  ViewController.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 14/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import UIKit


class IssuesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let tableView: UITableView = {
            let table = UITableView()
            table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            return table
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            title = "Issues"
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
        
        @objc func didTapAdd() {

            let vc = IssueController()
            present(vc, animated: true, completion: nil)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return issues.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Room Nr.\(issues[indexPath.row].room)"
            cell.detailTextLabel?.text = "Room Nr.\(issues[indexPath.row].room)"
            cell.imageView?.image = UIImage(systemName: "home")
            cell.imageView?.tintColor = .link
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        }
}

