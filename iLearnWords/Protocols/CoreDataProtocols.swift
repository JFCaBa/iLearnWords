//
//  CoreDataProtocols.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 15/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CloudKit

protocol CoreDataManagedObject {
    
//    func recordObjectToManaged() -> NSManagedObject
    func context() -> NSManagedObjectContext?
}

