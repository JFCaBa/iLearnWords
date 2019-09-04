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
            print("Could not save. \(error), \(error.userInfo)")
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
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    public func getTranslatedForWord(word: String) -> String? {
        
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
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
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
