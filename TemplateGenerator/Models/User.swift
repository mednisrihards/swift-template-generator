//
//  User.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 19/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import Foundation

class User : Codable {
    var name : String
    var lastName : String
    var email : String
    var company : String

    init(name : String, lastName : String, email : String, company : String) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.company = company
        self.name = name
        self.lastName = lastName
    }
}
