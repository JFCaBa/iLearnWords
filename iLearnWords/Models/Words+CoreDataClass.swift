//
//  Words+CoreDataClass.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 28/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Words)
public class Words: NSManagedObject {
    var coreData: CoreDataStack = CoreDataStack()
}
