//
//  Languages+CoreDataProperties.swift
//  
//
//  Created by Jose Francisco Catalá Barba on 14/09/2019.
//
//

import Foundation
import CoreData

extension Languages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Languages> {
        return NSFetchRequest<Languages>(entityName: "Languages")
    }

    @NSManaged public var isSelected: Bool
    @NSManaged public var recordID: Data?
    @NSManaged public var sayOriginal: String?
    @NSManaged public var sayTranslated: String?
    @NSManaged public var title: String?
    @NSManaged public var way: String?
    @NSManaged public var recordName: String?
    @NSManaged public var lastUpdate: Date?
    @NSManaged public var history: NSSet?

}

// MARK: Generated accessors for history
extension Languages {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: History)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: History)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}
