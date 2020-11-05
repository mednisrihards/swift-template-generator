//
//  EncodableExtension.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 19/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import Foundation

enum MyError: Error {
    case encodingError
}

extension Encodable {
    
    func toJson() throws -> [String : Any] {
        
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard let json = jsonObject as? [String : Any] else { throw MyError.encodingError }
        
        return json
    }
}
