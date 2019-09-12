//
//  DAOController.swift
//  iLearnWords
//
//  Created by Jose Catala on 03/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import CoreData
import SyncKit

class DAOController: NSObject {
    
    override init() {
        super.init()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

//        let synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "iCloud.com.armentechnology.iLearnWords", managedObjectContext: managedContext)

//        synchronizer.eraseLocalMetadata()
//        // Synchronize
//
//        synchronizer.synchronize { error in
//
//        }

    }
    //MARK: - Private functions
    //MARK: - Save methods
    public func save(original: String, translated: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Translated", in: managedContext)!
        let translateWay = UserDefaults.standard.value(forKey: UserDefaults.keys.TranslateWay) as! String
        let word = NSManagedObject(entity: entity, insertInto: managedContext)
        
        word.setValue(original, forKey: "original")
        word.setValue(translated, forKey: "trans")
        word.setValue(Date(), forKey: "date")
        word.setValue(translateWay, forKey: "translateWay")
        word.setValue(UUID().uuidString, forKey: "recordID")
        
        do {
            try managedContext.save()
            let synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "iCloud.com.armentechnology.iLearnWords", managedObjectContext: managedContext)
            
            // Synchronize
            synchronizer.synchronize { error in
                
            }
            return true
        } catch let error as NSError {
            print("Could not save Word. \(error), \(error.userInfo)")
            return false
        }
    }
    
    public func saveLanguage(title: String, short: String, say: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Languages", in: managedContext)!
        let lang = NSManagedObject(entity: entity, insertInto: managedContext)
        
        lang.setValue(title, forKey: "title")
        lang.setValue(short, forKey: "short")
        lang.setValue(say, forKey: "say")
        lang.setValue(UUID().uuidString, forKey: "recordID")
        
        do {
            try managedContext.save()
            let synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "iCloud.com.armentechnology.iLearnWords", managedObjectContext: managedContext)
            
            // Synchronize
            synchronizer.synchronize { error in
                
            }
            return true
        } catch let error as NSError {
            print("Could not save Language. \(error), \(error.userInfo)")
            return false
        }
    }
    
    public func saveHistory(_ word: Array<Words>, title: String = "Untitled") -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let history = History(context: managedContext)
        history.words = (NSSet(array: word))
        history.title = title
        history.isSelected = true
        history.translatedWay = (UserDefaults.standard.value(forKey: UserDefaults.keys.TranslateWay) as! String)
        history.talkOriginal = (UserDefaults.standard.value(forKey: UserDefaults.keys.TalkOriginal) as! String)
        history.talkTranslated = (UserDefaults.standard.value(forKey: UserDefaults.keys.TalkTranslate) as! String)
        history.date = Date()
        history.identifier = UUID().uuidString
        
        do {
            try managedContext.save()
            let synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "iCloud.com.armentechnology.iLearnWords", managedObjectContext: managedContext)
            
            // Synchronize
            synchronizer.synchronize { error in
                
            }
            return true
        } catch let error as NSError {
            print("Could not save history. \(error), \(error.userInfo)")
            return false
        }
    }
    
    public func saveWordObjectFrom(original: String, translated: String) -> Words? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let word = Words(context: managedContext)
        word.original = original
        word.translated = translated
        word.date = Date()
        word.identifier = UUID().uuidString
        
        do {
            try managedContext.save()
            let synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "iCloud.com.armentechnology.iLearnWords", managedObjectContext: managedContext)
            
            // Synchronize
            synchronizer.synchronize { error in
                
            }
            return word
        } catch let error as NSError {
            print("Could not save Word. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    //MARK: - Fetch methods
    public func fetchTranslatedForWord(word: String) -> String? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Words")
        fetchRequest.predicate = NSPredicate(format: "original = %@", word)

        do {
            let result = try managedContext.fetch(fetchRequest)
            let wordDb = result.first?.value(forKey: "translated") as? String
            return wordDb
            
        } catch let error as NSError {
            print("Could not fetch Translated Word. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    public func fetchSelectedHistory() -> History? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        let sort = NSSortDescriptor(key: #keyPath(History.date), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = NSPredicate(format: "isSelected == %@",NSNumber(value: true))
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let get = result.first {
                let history = get as! History
                return history
            }
            else {
                return nil
            }

        } catch let error as NSError {
            print("Could not fetch History. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    public func fetchAll(_ entity: String) -> Array<NSManagedObject>? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    public func fetchLanguages() -> Array<Languages>? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Languages")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return (result as! Array<Languages>)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    public func fetchCards() -> Array<Words>? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        let translateWay = UserDefaults.standard.value(forKey: UserDefaults.keys.TranslateWay) as! String
        fetchRequest.predicate = NSPredicate(format: "translatedWay == %@ && isSelected == %@", translateWay, NSNumber(value: true))
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let history = result.first as! History
            let toReturn = history.words!.allObjects as! Array<Words>
            return toReturn
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    //MARK: - Delete methods
    public func deleteObject(_ object: NSManagedObject) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(object)
        
        do {
            try managedContext.save()
            let synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "iCloud.com.armentechnology.iLearnWords", managedObjectContext: managedContext)
            
            // Synchronize
            synchronizer.synchronize { error in
                
            }
            return true
            
        } catch let error as NSError {
            print("Could not delete Object.\n \(error), \(error.userInfo)")
            return false
        }
    }
    
    //MARK: - Update methods
    public func updateObject(_ object: NSManagedObject) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.insert(object)
        
        do {
            try managedContext.save()
            let synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "iCloud.com.armentechnology.iLearnWords", managedObjectContext: managedContext)
            
            // Synchronize
            synchronizer.synchronize { error in
                
            }
            return true
            
        } catch let error as NSError {
            print("Could not Update Object.\n \(error), \(error.userInfo)")
            return false
        }
    }
    
    public func unSelectHistory() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "isSelected == %@",NSNumber(value: true))
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count > 0 {
                for history in result.compactMap({ $0 as? History }) {
                    history.isSelected = false
                    try managedContext.save()
                }
            }
            let synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "iCloud.com.armentechnology.iLearnWords", managedObjectContext: managedContext)
            
            // Synchronize
            synchronizer.synchronize { error in
                
            }
            return true
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    public func updateHistory(_ history: History) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "date == %@", history.date! as NSDate)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count > 0 {
                let hist = result.first as! History
                hist.isSelected = true
                try managedContext.save()
                let synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "iCloud.com.armentechnology.iLearnWords", managedObjectContext: managedContext)
                
                // Synchronize
                synchronizer.synchronize { error in
                    
                }
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
    
    public func updateWord(original: String, translated: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Words")
        fetchRequest.predicate = NSPredicate(format: "original == %@ && translated == %@", original,translated)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count > 0 {
                let word = result.first as! Words
                word.original = original
                word.translated = translated
                try managedContext.save()
                let synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "iCloud.com.armentechnology.iLearnWords", managedObjectContext: managedContext)
                
                // Synchronize
                synchronizer.synchronize { error in
                    
                }
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return 0
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        do {
            let count = try managedContext.count(for: fetchRequest)
            return count
        }
        catch let error as NSError {
            print("Could not retrive number of records. \(error), \(error.userInfo)")
            return 0
        }
    }
    public func cleanData(_ entity: String) -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            let synchronizer = CloudKitSynchronizer.privateSynchronizer(containerName: "iCloud.com.armentechnology.iLearnWords", managedObjectContext: managedContext)
            
            // Synchronize
            synchronizer.synchronize { error in
                
            }
            return true
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
            return false
        }
    }
}

