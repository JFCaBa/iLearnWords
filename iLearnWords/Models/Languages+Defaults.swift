//
//  Languages+Defaults.swift
//  iLearnWords
//
//  Created by Jose Catala on 01/10/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import Foundation
import CoreData

struct Languages_Defaults {
    
    func createLanguageEntityFrom(dictionary: [String: String], managedContext: NSManagedObjectContext) -> NSManagedObject? {
        if let languageEntity = NSEntityDescription.insertNewObject(forEntityName: UserDefaults.Entity.Languages, into: managedContext) as? Languages {
            languageEntity.title = dictionary[UserDefaults.Languages.Title]
            languageEntity.sayOriginal = dictionary[UserDefaults.Languages.SayOriginal]
            languageEntity.sayTranslated = dictionary[UserDefaults.Languages.SayTranslated]
            languageEntity.way = dictionary[UserDefaults.Languages.Way]
            languageEntity.isSelected = dictionary[UserDefaults.Languages.IsSelected] == "1" ? true : false
            let uuid = UUID().uuidString
            do {
                languageEntity.recordID = try NSKeyedArchiver.archivedData(withRootObject: uuid, requiringSecureCoding: false)
            }
            catch let error as NSError {
                print(error)
                return nil
            }
            languageEntity.recordName = UserDefaults.Entity.Languages + UUID().uuidString
            languageEntity.lastUpdate = Date()
            return languageEntity
        }
        return nil
    }
}
