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
    
    func save(original: String, translated: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Translated", in: managedContext)!
        
        let word = NSManagedObject(entity: entity, insertInto: managedContext)
        
        word.setValue(original, forKey: "original")
        word.setValue(translated, forKey: "trans")
        word.setValue(Date(), forKey: "date")
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func getTranslatedForWord(word: String) -> String? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Translated")
        fetchRequest.predicate = NSPredicate(format: "original = %@", word)

        do {
            let result = try managedContext.fetch(fetchRequest)
            let wordDb = result.first?.value(forKey: "trans") as? String
            return wordDb
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func cleanDB() -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Translated")
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
