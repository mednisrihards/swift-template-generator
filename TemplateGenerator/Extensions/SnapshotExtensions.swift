//
//  SnapshotExtensions.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 20/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension DocumentSnapshot {
    
    func decodeSnapshot<T: Decodable>(as ObjectType: T.Type) throws -> T {
        
        let documentJson = data()
        
        let documentData = try JSONSerialization.data(withJSONObject: documentJson as Any, options: [])
        let decodedObject = try JSONDecoder().decode(ObjectType, from: documentData)
        
        return decodedObject
    }
}
