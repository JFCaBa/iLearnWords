//
//  CoreDataManager.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataManager: NSObject {
    
    var managedContext: NSManagedObjectContext?
    
    var coreData = CoreDataStack.shared
    
    public override init() {
        super.init()
        managedContext = coreData.context()
    }
    
    /// To get the selected object in the passed entity. For the tables Language and History
    /// there is a property call isSelected
    ///
    /// - Parameters:
    ///  - entity: String with the name of the entity
    /// - Returns:
    ///  - The first NSManagedObject with the property isSelected to true (should be just one)
    func fetchSelectedByEntity(_ entity: String) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "isSelected == %@", NSNumber(value: true))
        do {
            let result = try managedContext?.fetch(fetchRequest)
            return result?.first
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}

extension CoreDataManager {
    
    func suportedLanguages() -> [[String: String]] {
        let langDic = [["title":"Russian to English",
                        "sayOriginal":"ru_RU",
                        "sayTranslated":"en_GB",
                        "way":"ru-en",
                        "isSelected":"1"],
                       ["title":"English to Russian",
                        "sayOriginal":"en_GB",
                        "sayTranslated":"ru_RU",
                        "way":"en-ru",
                        "isSelected":"0"]
        ]
        return langDic
    }
    
    func saveLanguagesInCoreDataWith() {
        let array = suportedLanguages()
        _ = array.map{self.createLanguageEntityFrom(dictionary: $0)}
        do {
            try managedContext?.save()
        } catch let error {
            print(error)
        }
    }
    
    func createLanguageEntityFrom(dictionary: [String: String]) -> NSManagedObject? {
        if let languageEntity = NSEntityDescription.insertNewObject(forEntityName: UserDefaults.Entity.Languages, into: managedContext!) as? Languages {
            languageEntity.title = dictionary[UserDefaults.Languages.Title]
            languageEntity.sayOriginal = dictionary[UserDefaults.Languages.SayOriginal]
            languageEntity.sayTranslated = dictionary[UserDefaults.Languages.SayTranslated]
            languageEntity.way = dictionary[UserDefaults.Languages.Way]
            languageEntity.isSelected = dictionary[UserDefaults.Languages.IsSelected] == "1" ? true : false
            let uuid = UUID().uuidString
            do {
                languageEntity.recordID = try NSKeyedArchiver.archivedData(withRootObject: uuid, requiringSecureCoding: false)
            }
            catch {
                print("Error")
                return nil
            }
            languageEntity.recordName = UserDefaults.Entity.Languages + UUID().uuidString
            languageEntity.lastUpdate = Date()
            return languageEntity
        }
        return nil
    }
}
