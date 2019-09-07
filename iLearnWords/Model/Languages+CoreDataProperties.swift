//
//  Languages+CoreDataProperties.swift
//  
//
//  Created by Jose Francisco Catalá Barba on 07/09/2019.
//
//

import Foundation
import CoreData


extension Languages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Languages> {
        return NSFetchRequest<Languages>(entityName: "Languages")
    }

    @NSManaged public var say: String?
    @NSManaged public var way: String?
    @NSManaged public var title: String?

}
