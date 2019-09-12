//
//  Languages+CoreDataProperties.swift
//  
//
//  Created by Jose Catala on 12/09/2019.
//
//

import Foundation
import CoreData


extension Languages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Languages> {
        return NSFetchRequest<Languages>(entityName: "Languages")
    }

    @NSManaged public var sayOriginal: String?
    @NSManaged public var sayTranslate: String?
    @NSManaged public var title: String?
    @NSManaged public var way: String?
    @NSManaged public var identifier: String?

}
