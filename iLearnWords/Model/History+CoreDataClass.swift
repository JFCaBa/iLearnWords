//
//  History+CoreDataClass.swift
//  
//
//  Created by Jose Catala on 12/09/2019.
//
//

import Foundation
import CoreData
import SyncKit

@objc(History)
public class History: NSManagedObject, PrimaryKey {
    static func primaryKey() -> String {
        return "identifier"
    }
}
