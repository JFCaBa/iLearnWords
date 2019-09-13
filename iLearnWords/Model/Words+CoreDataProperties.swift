//
//  Words+CoreDataProperties.swift
//  
//
//  Created by Jose Catala on 13/09/2019.
//
//

import Foundation
import CoreData


extension Words {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Words> {
        return NSFetchRequest<Words>(entityName: "Words")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var original: String?
    @NSManaged public var recordID: String?
    @NSManaged public var translated: String?
    @NSManaged public var history: History?

}
