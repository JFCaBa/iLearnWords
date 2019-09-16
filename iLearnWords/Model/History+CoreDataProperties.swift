//
//  History+CoreDataProperties.swift
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


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var isSelected: Bool
<<<<<<< HEAD
    @NSManaged public var recordID: String?
    @NSManaged public var title: String?
    @NSManaged public var language: Languages?
=======
    @NSManaged public var talkOriginal: String?
    @NSManaged public var talkTranslated: String?
    @NSManaged public var title: String?
    @NSManaged public var translatedWay: String?
    @NSManaged public var identifier: String?
>>>>>>> 6c8190a5346c9ed24f74a8093e6fb3f95a9fb685
    @NSManaged public var words: NSSet?

}

// MARK: Generated accessors for words
extension History {

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: Words)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: Words)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSSet)

}
