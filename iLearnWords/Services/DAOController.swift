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
    
    public override init() {
        super.init()

        managedContext = context()!
    }
    
    //MARK: - Private functions
    /// To get the managedContext to be used in the access to the database
    ///
    /// - Returns:
    ///  - NSManagedObjectContext: Instantiated in Appdelegate
    private func context() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
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
    private func fetchSelectedByEntity(_ entity: String) -> NSManagedObject? {
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
    
    /// To get all the objects in the table Languages
    ///
    /// - Returns:
    ///  - Array of Languages objects
    func fetchAll() -> Array<Languages> {
        if let result =  fetchAllByEntity("Languages"){
            return (result as! Array<Languages>)
        }
        else {
            return []
        }
    }
    
    /// To update the selected language
    ///
    /// - Parameters:
    ///  - Language entity selected by the user in the list
    /// - Returns:
    ///  - True if the operation was complete, false if not
    func updateSelectedLanguage(_ lang: Languages) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Languages")
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
    
    func fetchSelectedLanguage() -> Languages? {
        if let object = fetchSelectedByEntity("Languages") {
            return (object as! Languages)
        }
        else {
            return nil
        }
    }
    
    //MARK: - History
    /// To get all the objects in the table History
    ///
    /// - Returns:
    ///  - Array of History objects
    func fetchAll() -> Array<History> {
        if let result =  fetchAllByEntity("History"){
            return (result as! Array<History>)
        }
        else {
            return []
        }
    }
    
    func fetchSelectedHistory() -> History? {
        if let object = fetchSelectedByEntity("History") {
            return (object as! History)
        }
        else {
            return nil
        }
    }
    
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
        history.recordName = "History." + uuid
        history.lastUpdate = Date()
        history.language = fetchSelectedLanguage()
        do {
            try managedContext!.save()
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        do {
            let result = try managedContext?.fetch(fetchRequest)
            if result!.count > 0 {
                for history in result!.compactMap({ $0 as? History}) {
                    history.isSelected =  false
                }
                try managedContext?.save()
            }
            return true
            
        } catch let error as NSError {
            print("Could not Update selected Language. \(error), \(error.userInfo)")
            return false
        }
    }
    
    //MARK: - Words
    /// To get all the objects in the table History
    ///
    /// - Returns:
    ///  - Array of Words objects
    func fetchAll() -> Array<Words> {
        if let result =  fetchAllByEntity("Words"){
            return (result as! Array<Words>)
        }
        else {
            return []
        }
    }
    
    func saveArrayOfWords(_ words: Array<Words>) -> Array<NSManagedObject>? {
        var retArray: Array<NSManagedObject> = []
        for (_, element) in words.enumerated() {
            if let wordEntity = NSEntityDescription.insertNewObject(forEntityName: "Words", into: managedContext!) as? Words {
                wordEntity.original = element.original
                wordEntity.translated = element.translated
                let uuid = UUID().uuidString
                wordEntity.recordID = Data(base64Encoded: uuid)
                wordEntity.recordName = "Words." + uuid
                wordEntity.lastUpdate = Date()
                retArray.append(wordEntity)
            }
            do {
                try managedContext!.save()
            }
            catch let error {
                print(error)
            }
        }
        
        return retArray
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
        word.recordName = "Words." + uuid
        return word
    }
    
    public func fetchTranslatedForWord(word: String) -> String? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Words")
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
    
    public func unSelectHistory() -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "isSelected == %@",NSNumber(value: true))
        do {
            let result = try managedContext?.fetch(fetchRequest)
            if result!.count > 0 {
                for history in result!.compactMap({ $0 as? History }) {
                    history.isSelected = false
                    try managedContext!.save()
                }
            }

            return true
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    public func updateWord(original: String, translated: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Words")
        fetchRequest.predicate = NSPredicate(format: "original == %@ && translated == %@", original,translated)
        
        do {
            let result = try managedContext?.fetch(fetchRequest)
            if result!.count > 0 {
                let word = result?.first as! Words
                word.original = original
                word.translated = translated
                try managedContext!.save()
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
    public func numberOfRecords(_ entity: String) -> Int {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        do {
            let count = try managedContext!.count(for: fetchRequest)
            return count
        }
        catch let error as NSError {
            print("Could not retrive number of records. \(error), \(error.userInfo)")
            return 0
        }
    }
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
        self.cloud.fetchLanguages(completionHandler: { (records) -> Void? in
            if nil != records {
                //Iterate the records..
                DispatchQueue.main.async {
                    for (_ ,element) in (records!.enumerated()) {
                        let lang = Languages(context: self.managedContext!)
                        _ = lang.recordToManagedObject(element as! CKRecord) as! Languages
                    }
                }
            }
            group.leave()
            return nil
        })
        
//        group.enter()
//        self.cloud.fetchWords(completionHandler: { (records) -> Void? in
//            if nil != records {
//                var retArray: Array<Words> = []
//                //Iterate the records..
//                DispatchQueue.main.async {
//                    for (_ ,element) in (records!.enumerated()) {
//                        let word = Words(context: self.managedContext!)
//                        let managed = word.recordToManagedObject(element as! CKRecord) as! Words
//                        retArray.append(managed)
//                    }
//                }
//            }
//            group.leave()
//            return nil
//        })
        
//        group.enter()
//        self.cloud.fetchHistory(completionHandler: { (records) -> Void? in
//            if nil != records {
//                var retArray: Array<History> = []
//                //Iterate the records..
//                DispatchQueue.main.async {
//                    for (_ ,element) in (records!.enumerated()) {
//                        let hist = History(context: self.managedContext!)
//                        let managed = hist.recordToManagedObject(element as! CKRecord) as! History
//                        retArray.append(managed)
//                    }
//                }
//            }
//            group.leave()
//            return nil
//        })
        
        group.notify(queue: DispatchQueue.main) {

        }
    }
    
    func saveContext (_ contextManager: NSManagedObjectContext) {
        if contextManager.hasChanges {
            do {
                try contextManager.save()
            } catch {
                NSLog("Core Data SaveContext Error: \(error.localizedDescription)")
            }
        }
    }
    
    func syncLanguagesWithHistory(_ contextManager: NSManagedObjectContext, completionHandler: @escaping (Error?) -> Void) {
        
    }
    
    
    func syndWordsWithHistory(_ contextManager: NSManagedObjectContext, completionHandler: @escaping (Error?) -> Void) {
        
    }
}
