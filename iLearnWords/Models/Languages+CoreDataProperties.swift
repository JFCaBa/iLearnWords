//
//  Languages+CoreDataProperties.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 28/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//
//

import Foundation
import CoreData


extension Languages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Languages> {
        return NSFetchRequest<Languages>(entityName: "Languages")
    }

    @NSManaged public var sayOriginal: String?
    @NSManaged public var sayTranslated: String?
    @NSManaged public var title: String?
    @NSManaged public var way: String?
    @NSManaged public var isSelected: Bool
    @NSManaged public var recordID: Data?
    @NSManaged public var recordName: String?
    @NSManaged public var lastUpdate: Date?
    @NSManaged public var history: History?

}
