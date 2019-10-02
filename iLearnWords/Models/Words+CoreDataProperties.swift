//
//  Words+CoreDataProperties.swift
//  iLearnWords
//
//  Created by Jose Catala on 02/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
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
    @NSManaged public var recordID: Data?
    @NSManaged public var recordName: String?
    @NSManaged public var translated: String?
    @NSManaged public var created: Double
    @NSManaged public var history: History?

}
