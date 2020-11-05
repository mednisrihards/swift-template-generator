//
//  Responsible.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 14/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import Foundation

class Responsible : Codable {
    var name : String
    var certNr : String
    var comment : String?

    init(name: String, certNr : String, comment : String?) {
        self.name = name
        self.certNr = certNr
        self.comment = comment
    }
}
