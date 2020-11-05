//
//  FIRFirestoreService.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 14/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class FIRFirestoreService {

    private init() {}
    
    static let shared = FIRFirestoreService()
    
    public let reference = Firestore.firestore()
    
    private let storage = Storage.storage().reference()
    
    private let company = UserDefaults.standard.string(forKey: "company")
    
    func configure() {
        FirebaseApp.configure()
    }
    
    /// Inserts new user to database
    public func insertUser(with user: User){

        reference.collection("users").document(user.email).getDocument { (document, error) in
            if let document = document, document.exists {
                print("User already exists")
            } else {
                do {
                    self.reference.collection("users").document(user.email).setData(try user.toJson())
                } catch {
                    print("writing to Firebase error: \(error)")
                }
            }
        }
    }
    
    ///Sets user company name to user defaults
    public func setCompany(with email: String) {
        reference.collection("users").document(email).getDocument { (document, error) in
            if let document = document, document.exists {
                UserDefaults.standard.set(document.get("company"), forKey: "company")
            }
        }
    }
    
    /// Fetches database and returns an array of Projects
    public func getAllProjects(with company: String, completion: @escaping ([Project]) -> Void) {
        
        reference.collection(company).document("docs").collection("defektacija").addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            var projects = [Project]()
            
            do {
                for document in snapshot.documents {
                    projects.append(Project(contractNumber: (document.get("contractNumber") ?? "") as! String, address: (document.get("address") ?? "") as! String, date: (document.get("date") ?? "") as! String))
                }
                completion(projects)
            } catch {
                print(error)
            }
        }
    }
    
    /// Gets the current project by contractNumber
    public func getProject(with address: String, completion: @escaping ([Project]) -> Void) {

        reference.collection(company!).document("docs").collection("defektacija").document(address).getDocument { (document, error) in
            
          if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
        }
    }
    
    /// Saves project data into Firebase database
    public func addProject(with project: Project, completion: @escaping (String) -> Void) {
        
        do {
            reference.collection(company!).document("docs").collection("defektacija").document(project.address).setData(try project.toJson())
        } catch {
            print(error)
        }
    }

    ///Adds responsibles to the Project
    public func addResponsibles(with project: Project, responsibles: [Responsible], completion: @escaping (String) -> Void) {
        
        do {
            try responsibles.forEach { (responsible) in
                reference.collection(company!).document("docs").collection("defektacija").document(project.address).collection("papildus").document("atbildigie").collection(responsible.name).document("data").setData(try responsible.toJson(), merge: false)
            }
        }catch {
                print(error)
            }
        }

    ///Uploads issues from array to Firebase
    public func addIssues(with project: Project, issueArray: [Issue]) {
        var index = 0
        
        do {
            try issueArray.forEach { (issue) in
                reference.collection(company!).document("docs").collection("defektacija").document(project.address).collection("papildus").document("defekti").collection(issue.room).document(String(index)).setData(try issue.toJson(), merge: false)
                
//                storage.child("images/\(company!)/\(project.contractNumber)/\(issue.room)/\(issue.imageFileName)").putData(issue.imageData, metadata: nil)
                
                index+=1
                
                var roomNumber = issue.room {
                    didSet {
                        if roomNumber == oldValue {
                            print("Index \(index) ")
                        } else {
                            index = 0
                        }
                    }
                }
            }
        }catch {
                print(error)
            }
        }
    
    }
