//
//  History+CoreDataProperties.swift
//  
//
//  Created by Jose Francisco Catalá Barba on 07/09/2019.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var isSelected: Bool
    @NSManaged public var hasWord: NSSet?

}

// MARK: Generated accessors for hasWord
extension History {

    @objc(addHasWordObject:)
    @NSManaged public func addToHasWord(_ value: Words)

    @objc(removeHasWordObject:)
    @NSManaged public func removeFromHasWord(_ value: Words)

    @objc(addHasWord:)
    @NSManaged public func addToHasWord(_ values: NSSet)

    @objc(removeHasWord:)
    @NSManaged public func removeFromHasWord(_ values: NSSet)

}
