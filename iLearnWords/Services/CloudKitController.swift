//
//  CloudKitController.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 13/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitController {
    
    // Represents the default container specified in the iCloud section of the Capabilities tab for the project.
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    // MARK: - Initializers
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    func fetchLanguages() -> Array<Languages>? {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Languages", predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { records, error in
            guard let languages = records else { return }
            //Use the records..
            
        }
        return nil
    }
}
