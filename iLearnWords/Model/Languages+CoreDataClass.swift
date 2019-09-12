//
//  Languages+CoreDataClass.swift
//  
//
//  Created by Jose Catala on 12/09/2019.
//
//

import Foundation
import CoreData
import SyncKit

@objc(Languages)
public class Languages: NSManagedObject, PrimaryKey {
    static func primaryKey() -> String {
        return "identifier"
    }   
}
