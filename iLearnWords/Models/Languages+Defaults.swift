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
    
    static let languagesArray = [["title":"Russian to English",
                                  "sayOriginal":"ru_RU",
                                  "sayTranslated":"en_GB",
                                  "way":"ru-en",
                                  "isSelected":"1"],
                                 ["title":"Spanish a Russian",
                                  "sayOriginal":"es_ES",
                                  "sayTranslated":"ru_RU",
                                  "way":"es-ru",
                                  "isSelected":"0"],
                                 ["title":"Russian to Spanish",
                                 "sayOriginal":"ru_RU",
                                 "sayTranslated":"es_ES",
                                 "way":"ru-es",
                                 "isSelected":"0"],
                                 ["title":"English to Russian",
                                  "sayOriginal":"en_GB",
                                  "sayTranslated":"ru_RU",
                                  "way":"en-ru",
                                  "isSelected":"0"],
                                  ["title":"English to Spanish",
                                   "sayOriginal":"en_GB",
                                   "sayTranslated":"es_ES",
                                   "way":"en-es",
                                   "isSelected":"0"],
                                   ["title":"Spanish to English",
                                    "sayOriginal":"es_ES",
                                    "sayTranslated":"en_GB",
                                    "way":"es-en",
                                    "isSelected":"0"]
    ]
    
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
