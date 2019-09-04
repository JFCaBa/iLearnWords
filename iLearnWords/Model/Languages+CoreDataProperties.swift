//
//  Languages+CoreDataProperties.swift
//  
//
//  Created by Jose Catala on 04/09/2019.
//
//

import Foundation
import CoreData


extension Languages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Languages> {
        return NSFetchRequest<Languages>(entityName: "Languages")
    }

    @NSManaged public var title: String?
    @NSManaged public var short: String?
    @NSManaged public var read: String?

}
