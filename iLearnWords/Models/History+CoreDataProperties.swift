//
//  History+CoreDataProperties.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 28/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var lastUpdate: Date?
    @NSManaged public var isSelected: Bool
    @NSManaged public var title: String?
    @NSManaged public var recordID: Data?
    @NSManaged public var recordName: String?
    @NSManaged public var hasWord: NSSet?
    @NSManaged public var language: Languages?
    @NSManaged public var words: NSSet?
    @NSManaged public var created: Double

}

// MARK: Generated accessors for hasWord
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
