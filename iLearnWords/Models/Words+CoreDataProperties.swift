//
//  Words+CoreDataProperties.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 28/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//
//

import Foundation
import CoreData


extension Words {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Words> {
        return NSFetchRequest<Words>(entityName: "Words")
    }

    @NSManaged public var lastUpdate: Date?
    @NSManaged public var original: String?
    @NSManaged public var translated: String?
    @NSManaged public var recordID: Data?
    @NSManaged public var recordName: String?
    @NSManaged public var history: History?
}
