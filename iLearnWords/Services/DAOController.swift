//
//  DAOController.swift
//  iLearnWords
//
//  Created by Jose Catala on 03/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

public class DAOController: NSObject {
    
    let cloud: CloudKitController = CloudKitController()
    var managedContext: NSManagedObjectContext?
    
    var coreData = CoreDataController.shared
    
    
    public override init() {
        super.init()

        managedContext = coreData.context()
    }
    
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
    
    //MARK: - Languages
    //Helper functions to Store the defaults values into the Languages Entity
    func createLanguageEntityFrom(dictionary: [String: String]) -> NSManagedObject? {
        if let languageEntity = NSEntityDescription.insertNewObject(forEntityName: "Languages", into: managedContext!) as? Languages {
            languageEntity.title = dictionary[UserDefaults.Languages.Title]
            languageEntity.sayOriginal = dictionary[UserDefaults.Languages.SayOriginal]
            languageEntity.sayTranslated = dictionary[UserDefaults.Languages.SayTranslated]
            languageEntity.way = dictionary[UserDefaults.Languages.Way]
            languageEntity.isSelected = dictionary[UserDefaults.Languages.IsSelected] == "1" ? true : false
            return languageEntity
        }
        return nil
    }
    
    func saveInCoreDataWith(array: [[String: String]]) {
        _ = array.map{self.createLanguageEntityFrom(dictionary: $0)}
        do {
            try managedContext?.save()
        } catch let error {
            print(error)
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
    
    //MARK: - History
    
    /// To save the paste history
    ///
    /// - Parameters:
    ///  - words:  The array of words entities pasted by the user
    ///  - title:  The title for this history
    ///  - lang:   The language entity used for the paste/translation
    /// - Returns:
    ///  - History: The saved entity
    func saveHistory(_ words: Array<NSManagedObject>, title: String = "Untitled") -> History? {
        let history = History(context: managedContext!)
        _ = updateSelectedHistory(history)
        history.addToWords(NSSet(array: words))
        history.isSelected = true
        history.title = title
        let uuid = UUID().uuidString
        history.recordID = Data(base64Encoded: uuid)
        history.recordName = UserDefaults.Entity.History + "." + uuid
        history.lastUpdate = Date()
        history.language = (fetchSelectedByEntity(UserDefaults.Entity.Languages) as! Languages)
        do {
            try managedContext!.save()
            //Upload Hitory to the Cloud
            cloud.saveHistory(history, managedContext: managedContext!)
            return history
        } catch let error as NSError {
            print("Could not save history. \(error), \(error.userInfo)")
            return nil
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
    
    
    /// To save a new word in the table
    ///
    /// - Parameters:
    ///  - original:   The word the user pasted
    ///  - translated: The word the system did translate
    ///  - history:    The history entity the words will be associated to
    ///
    /// - Returns:
    ///  - True if the word was saved, false if not
    func save(original: String, translated: String, history: History) -> Bool {
        let word = Words(context: managedContext!)
        word.original = original
        word.translated = translated
        word.recordID = Data(base64Encoded: UUID().uuidString)
        word.lastUpdate = Date()
        word.history = history
        do {
            try managedContext!.save()
            return true
        } catch let error as NSError {
            print("Could not save Word. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func wordObjectFrom(original: String, translated: String) -> Words? {
        let word = Words(context: managedContext!)
        word.original = original
        word.translated = translated
        word.lastUpdate = Date()
        let uuid = UUID().uuidString
        word.recordID = Data(base64Encoded: uuid)
        word.recordName = UserDefaults.Entity.Words + "." + uuid
        return word
    }
    
    public func fetchTranslatedForWord(word: String) -> String? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: UserDefaults.Entity.Words)
        fetchRequest.predicate = NSPredicate(format: "original = %@", word)
        
        do {
            let result = try managedContext?.fetch(fetchRequest)
            let wordDb = result?.first?.value(forKey: "translated") as? String
            return wordDb
            
        } catch let error as NSError {
            print("Could not fetch Translated Word. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    
    //MARK: - Delete methods
    public func deleteObject(_ object: NSManagedObject) -> Bool {
        managedContext!.delete(object)
        do {
            try managedContext!.save()
            return true
            
        } catch let error as NSError {
            print("Could not delete Object.\n \(error), \(error.userInfo)")
            return false
        }
    }
    
    //MARK: - Update methods
    public func updateObject(_ object: NSManagedObject) -> Bool {
        managedContext!.insert(object)
        do {
            try managedContext!.save()
            return true
            
        } catch let error as NSError {
            print("Could not Update Object.\n \(error), \(error.userInfo)")
            return false
        }
    }
    
    
    public func updateWord(original: String, translated: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: UserDefaults.Entity.Words)
        fetchRequest.predicate = NSPredicate(format: "original == %@ && translated == %@", original,translated)
        do {
            let result = try managedContext?.fetch(fetchRequest)
            if result!.count > 0 {
                let word = result?.first as! Words
                word.original = original
                word.translated = translated
                try managedContext!.save()
                //Update word to CloudKit
                cloud.saveCkWord(word)
                return true
            }
            else {
                return false
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    //MARK: - Aux methods
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
}

extension DAOController {
    
    func synchronizeData() {
        let group = DispatchGroup()
        group.enter()
        
        var languages: Array<CKRecord> = []
        var history: Array<CKRecord> = []
        var words: Array<CKRecord> = []
        
        self.cloud.fetchLanguages(completionHandler: { (records) -> Void? in
            if nil != records {
                for (_, element) in records!.enumerated() {
                    let record = element as! CKRecord
                    languages.append(record)
                }
            }
            group.leave()
            return nil
        })
        
        group.enter()
        self.cloud.fetchWords(completionHandler: { (records) -> Void? in
            if nil != records {
                for (_, element) in records!.enumerated() {
                    let record = element as! CKRecord
                    words.append(record)
                }
            }
            group.leave()
            return nil
        })
        
        group.enter()
        self.cloud.fetchHistory(completionHandler: { (records) -> Void? in
            if nil != records {
                for (_, element) in records!.enumerated() {
                    let record = element as! CKRecord
                    history.append(record)
                }
            }
            group.leave()
            return nil
        })
        
        group.notify(queue: DispatchQueue.main) {
            if languages.count > 0 {
                self.syncLanguages(languages)
            }
            
            if words.count > 0 {
                self.syncWordsWithHistory(words)
            }
            
            if history.count > 0 {
                self.syncLanguagesWithHistory(history)
            }
        }
    }
    
    func saveContext () {
        if managedContext!.hasChanges {
            do {
                try managedContext!.save()
            } catch {
                NSLog("Core Data SaveContext Error: \(error.localizedDescription)")
            }
        }
    }
    
    func syncLanguages(_ sender: Array<CKRecord>) {
        let lang = Languages(context: self.managedContext!)
        coreData.context()?.delete(lang)
        lang.recordsToManagedObjects(sender)
    }
    
    func syncLanguagesWithHistory(_ sender: Array<CKRecord>) {
        let hist = History(context: self.managedContext!)
        coreData.context()?.delete(hist)
        hist.recordsToManagedObjects(sender)
    }
    
    func syncWordsWithHistory(_ sender: Array<CKRecord>) {
        let word = Words(context: self.managedContext!)
        coreData.context()?.delete(word)
        word.recordsToManagedObjects(sender)
    }
}
