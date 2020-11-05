//
//  AlertService.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 14/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    private init(){}
    
    static func alertMsg(in vc: UIViewController, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    
    
    
    
    
    
    
    
    static func addResponsible (in vc: UIViewController, completion: @escaping (Responsible) -> Void) {
        let alert = UIAlertController(title: "Add responsible", message: nil, preferredStyle: .alert)
        
        
        alert.addTextField { (name) in
            name.placeholder = "Responsible person"
        }
        alert.addTextField { (certNr) in
            certNr.placeholder = "Certificate number"
        }
        alert.addTextField { (comment) in
            comment.placeholder = "Comment"
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alert.textFields?.first?.text, let comment = alert.textFields?.last?.text, let certNr = alert.textFields?[1].text, !name.isEmpty, !certNr.isEmpty else {
                return
            }
            completion(Responsible(name: name, certNr: certNr, comment: comment))
        }
        alert.addAction(add)
        vc.present(alert, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    static func updateResponsible (in vc: UIViewController, Responsible: Responsible, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Update responsible", message: nil, preferredStyle: .alert)
        alert.addTextField { (responsibleField) in
            responsibleField.placeholder = "Responsible person"
            responsibleField.text = Responsible.name
        }
        let update = UIAlertAction(title: "Update", style: .default) { _ in
            guard let responsible = alert.textFields?.last?.text, !responsible.isEmpty else {
                return
            }
            completion(responsible)
        }
        alert.addAction(update)
        vc.present(alert, animated: true)
    }
}
