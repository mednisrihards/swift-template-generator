//
//  Issue.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 14/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import Foundation

class Issue : Codable {
    var room : String
    var description : String
    var imageFileName : String
//    var imageData : Data
    
    init(room: String, description: String, imageFileName: String) {
        self.room = room
        self.description = description
        self.imageFileName = imageFileName
//        self.imageData = imageData
    }
}
