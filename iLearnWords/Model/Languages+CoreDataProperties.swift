//
//  Languages+CoreDataProperties.swift
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


extension Languages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Languages> {
        return NSFetchRequest<Languages>(entityName: "Languages")
    }

    @NSManaged public var recordID: String?
    @NSManaged public var sayOriginal: String?
    @NSManaged public var sayTranslate: String?
    @NSManaged public var title: String?
    @NSManaged public var way: String?
<<<<<<< HEAD
    @NSManaged public var isSelected: Bool
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
=======
    @NSManaged public var identifier: String?
>>>>>>> 6c8190a5346c9ed24f74a8093e6fb3f95a9fb685

}
