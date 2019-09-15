//
//  Words+CoreDataProperties.swift
//  
//
//  Created by Jose Francisco Catalá Barba on 14/09/2019.
//
//

import Foundation
import CoreData
import CloudKit

extension Words {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Words> {
        return NSFetchRequest<Words>(entityName: "Words")
    }

    @NSManaged public var lastUpdate: Date?
    @NSManaged public var original: String?
    @NSManaged public var recordID: Data?
    @NSManaged public var translated: String?
    @NSManaged public var recordName: String?
    @NSManaged public var history: History?
}
