//
//  Words+CoreDataClass.swift
//  
//
<<<<<<< HEAD
//  Created by Jose Catala on 13/09/2019.
=======
//  Created by Jose Catala on 12/09/2019.
>>>>>>> 6c8190a5346c9ed24f74a8093e6fb3f95a9fb685
//
//

import Foundation
import CoreData
import SyncKit

@objc(Words)
public class Words: NSManagedObject, PrimaryKey {
    static func primaryKey() -> String {
        return "identifier"
    }
    
    static func parentKey() -> String {
        return "history"
    }
}
