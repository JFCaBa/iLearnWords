//
//  Translated+CoreDataProperties.swift
//  
//
//  Created by Jose Catala on 03/09/2019.
//
//

import Foundation
import CoreData


extension Translated {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Translated> {
        return NSFetchRequest<Translated>(entityName: "Translated")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var original: String?
    @NSManaged public var trans: String?

}
