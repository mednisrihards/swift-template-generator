//
//  Project.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 14/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import Foundation

class Project : Codable {
    var contractNumber : String
    var address : String
    var date : String

    init(contractNumber : String, address : String, date : String) {
        self.contractNumber = contractNumber
        self.address = address
        self.date = date
    }
}
