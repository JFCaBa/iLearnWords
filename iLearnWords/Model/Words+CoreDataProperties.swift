//
//  Words+CoreDataProperties.swift
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


extension Words {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Words> {
        return NSFetchRequest<Words>(entityName: "Words")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var original: String?
    @NSManaged public var recordID: String?
    @NSManaged public var translated: String?
<<<<<<< HEAD
=======
    @NSManaged public var identifier: String?
>>>>>>> 6c8190a5346c9ed24f74a8093e6fb3f95a9fb685
    @NSManaged public var history: History?

}
