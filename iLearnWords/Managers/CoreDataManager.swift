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
    
    // MARK: - Fetch
    
    /// To get all the objects associated to the entity passed as parameter
    ///
    /// - Parameters:
    ///  - entity: String with the name of the entity
    /// - Returns:
    ///  - Array containig all the objects in the table
    func fetchAllByEntity(_ entity: String) -> Array<NSManagedObject>? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        do {
            let result = try managedContext?.fetch(fetchRequest)
            return result
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    /// To get the selected object in the passed entity. For the tables Language and History
    /// there is a property call isSelected
    ///
    /// - Parameters:
    ///  - entity: String with the name of the entity
    /// - Returns:
    ///  - The first NSManagedObject with the property isSelected to true (should be just one)
    public func fetchSelectedByEntity(_ entity: String) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "isSelected == %@", NSNumber(value: true))
        let sectionSortDescriptor = NSSortDescriptor(key: "lastUpdate", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let result = try managedContext?.fetch(fetchRequest)
            return result?.first
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    // MARK: - Save
    
    /// To save the NSManagedObject with the common properties
    ///
    /// - Parameters:
    ///  - entity: The NSManagedObject: History / Word / Language
    /// - Returns:
    ///  - True if the operation was succes, false otherwise
    public func saveEntity(entity: NSManagedObject) {
        let name = UserDefaults.Entity.Words + UUID().uuidString
        entity.setValue(name, forKey: "recordName")
        entity.setValue(Date(), forKey: "lastUpdate")
        let uuid = UUID().uuidString
        do {
            let key = try NSKeyedArchiver.archivedData(withRootObject: uuid, requiringSecureCoding: false)
            entity.setValue(key, forKey:"recordID")
        }
         catch let error as NSError {
            print(error)
            return
        }
    }
    
    // MARK: - Delete
    
    /// To delete the NSManagedObject
    ///
    /// - Parameters:
    ///  - entity: The NSManagedObject: History / Word / Language
    /// - Returns:
    ///  - True if the operation was succes, false otherwise
    public func deleteObject(_ entity: NSManagedObject) -> Bool {
        managedContext!.delete(entity)
        do {
            try managedContext!.save()
            return true
            
        } catch let error as NSError {
            print("Could not delete Object.\n \(error), \(error.userInfo)")
            return false
        }
    }
    
    /// To clean the content of the data base
    ///
    /// - Parameters:
    ///  - entity: String with the name of the entity
    /// - Returns:
    ///  - True if the operation was succes, false otherwise
    public func cleanData(_ entity: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedContext!.execute(deleteRequest)
            try managedContext!.save()
            return true
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
            return false
        }
    }
    
    // MARK: - Update
    
    /// To update the NSManagedObject
    ///
    /// - Parameters:
    ///  - entity: The NSManagedObject: History / Word / Language
    /// - Returns:
    ///  - True if the operation was succes, false otherwise
    public func updateObject(_ entity: NSManagedObject) -> Bool {
        managedContext!.insert(entity)
        do {
            try managedContext!.save()
            return true
            
        } catch let error as NSError {
            print("Could not Update Object.\n \(error), \(error.userInfo)")
            return false
        }
    }
    
    /// To update the selected History
    ///
    /// - Parameters:
    ///  - Language entity selected by the user in the list
    /// - Returns:
    ///  - True if the operation was complete, false if not
    func updateSelectedHistory(_ hist: History) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: UserDefaults.Entity.History)
        do {
            let result = try managedContext?.fetch(fetchRequest)
            if result!.count > 0 {
                for history in result!.compactMap({ $0 as? History}) {
                    history.isSelected =  false
                }
                hist.isSelected = true
                try managedContext?.save()
            }
            return true
            
        } catch let error as NSError {
            print("Could not Update selected Language. \(error), \(error.userInfo)")
            return false
        }
    }
    
    /// To update the selected language
    ///
    /// - Parameters:
    ///  - Language entity selected by the user in the list
    /// - Returns:
    ///  - True if the operation was complete, false if not
    func updateSelectedLanguage(_ lang: Languages) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: UserDefaults.Entity.Languages)
        do {
            let result = try managedContext?.fetch(fetchRequest)
            if result!.count > 0 {
                for language in result!.compactMap({ $0 as? Languages }) {
                    language.isSelected = language.recordID == lang.recordID ? true : false
                    try managedContext!.save()
                }
            }
            return true
            
        } catch let error as NSError {
            print("Could not Update selected Language. \(error), \(error.userInfo)")
            return false
        }
    }
}

// MARK: - Languages table iniatilaser
extension CoreDataManager {
    /// Will save the Languages defined in Configuration.swift
    /// into the Core Data data base
    func saveLanguagesInCoreDataWith() {
        let landDefaults = Languages_Defaults()
        let array = TranslationLanguages.languagesArray
        if let managedContext = managedContext {
            _ = array.map{landDefaults.createLanguageEntityFrom(dictionary: $0, managedContext: managedContext)}
            do {
                try managedContext.save()
            } catch let error as NSError {
                print(error)
            }
        }
    }
}
