//
//  Words+CoreDataClass.swift
//  
//
//  Created by Jose Francisco Catalá Barba on 14/09/2019.
//
//

import Foundation
import UIKit
import CoreData
import CloudKit

class Words: NSManagedObject, CloudKitManagedObject, CoreDataManagedObject
{
    func context() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    var recordType: String { return UserDefaults.Entity.Words }
    func managedObjectToRecord() -> CKRecord {
        guard   let original = original,
        let translated = translated
            else {
                fatalError("Required properties for record not set")
        }
        
        let record = cloudKitRecord()
        record[UserDefaults.Words.Original]          = original as CKRecordValue
        record[UserDefaults.Words.Translated]        = translated as CKRecordValue
        return record
    }
    
    func recordToManagedObject(_ record: CKRecord) -> NSManagedObject? {
        let managedContext = context()
        let word = Words(context: managedContext!)
        do {
            word.recordID = try NSKeyedArchiver.archivedData(withRootObject: record.recordID, requiringSecureCoding: false)
            word.recordName = record.recordID.recordName
            word.lastUpdate = record[UserDefaults.Words.LastUpdate]
            word.original = record[UserDefaults.Words.Original] as? String
            word.translated = record[UserDefaults.Words.Translated] as? String
            return word
        }
        catch {
            return nil
        }
    }
}
