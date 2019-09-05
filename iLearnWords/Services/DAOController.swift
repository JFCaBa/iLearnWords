//
//  DAOController.swift
//  iLearnWords
//
//  Created by Jose Catala on 03/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import CoreData

class DAOController: NSObject {
    
    //MARK: - Save methods
    public func save(original: String, translated: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Translated", in: managedContext)!
        let translateWay = UserDefaults.standard.value(forKey: "TRANSLATE_WAY") as! String
        let word = NSManagedObject(entity: entity, insertInto: managedContext)
        
        word.setValue(original, forKey: "original")
        word.setValue(translated, forKey: "trans")
        word.setValue(Date(), forKey: "date")
        word.setValue(translateWay, forKey: "translateWay")
        
        do {
            try managedContext.save()
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
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save Language. \(error), \(error.userInfo)")
            return false
        }
    }
    
    public func saveHistory(_ history: String, title: String = "Untitled") -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "History", in: managedContext)!
        let hist = NSManagedObject(entity: entity, insertInto: managedContext)
        
        hist.setValue(history, forKey: "text")
        hist.setValue(title, forKey: "title")
        hist.setValue(Date(), forKey: "date")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save history. \(error), \(error.userInfo)")
            return false
        }
    }
    
    //MARK: - Fetch methods
    public func fetchTranslatedForWord(word: String) -> String? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let translateWay = UserDefaults.standard.value(forKey: "TRANSLATE_WAY") as! String
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Translated")
        fetchRequest.predicate = NSPredicate(format: "original = %@ and translateWay = %@", word, translateWay)

        do {
            let result = try managedContext.fetch(fetchRequest)
            let wordDb = result.first?.value(forKey: "trans") as? String
            return wordDb
            
        } catch let error as NSError {
            print("Could not fetch Translated Word. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    public func fetchLastHistory() -> String? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let history = result.first?.value(forKey: "text") as? String
            return history
            
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
    
    //MARK: - Delete methods
    public func deleteObject(_ entity: String, object: NSManagedObject) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(object)
        
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            print("Could not delete Object.\n \(error), \(error.userInfo)")
            return false
        }
    }
    
    //MARK: - Update methods
    
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
            return true
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
            return false
        }
    }
}
