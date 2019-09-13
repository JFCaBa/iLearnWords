//
//  History+CoreDataProperties.swift
//  
//
//  Created by Jose Catala on 13/09/2019.
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
    @NSManaged public var recordID: String?
    @NSManaged public var title: String?
    @NSManaged public var language: Languages?
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
