//
//  Words+CoreDataClass.swift
//  
//
//  Created by Jose Catala on 12/09/2019.
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
