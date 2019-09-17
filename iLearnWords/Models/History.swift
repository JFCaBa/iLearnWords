//
//  History+CoreDataClass.swift
//  
//
//  Created by Jose Francisco Catalá Barba on 14/09/2019.
//
//

import Foundation
import UIKit
import CoreData
import CloudKit

class History: NSManagedObject, CloudKitManagedObject {
    
    var coreData = CoreDataController.shared
    
    var recordType: String { return UserDefaults.Entity.History }
    func managedObjectToRecord() -> CKRecord {
        guard   let title = title
            else {
                fatalError("Required properties for record not set")
        }
        
        let record = cloudKitRecord()
        record[UserDefaults.History.Title]          = title as CKRecordValue
        record[UserDefaults.History.IsSelected]     = isSelected as CKRecordValue
        record[UserDefaults.Languages.LastUpdate]   = Date() as CKRecordValue
        return record
    }
    
    func recordToManagedObject(_ record: CKRecord) -> NSManagedObject? {
        let managedContext = coreData.context()
        let hist = History(context: managedContext!)
        do {
            hist.recordID = try NSKeyedArchiver.archivedData(withRootObject: record.recordID, requiringSecureCoding: false)
            hist.recordName = record.recordID.recordName
            hist.lastUpdate = record[UserDefaults.Languages.LastUpdate]
            hist.title = record[UserDefaults.Languages.Title] as? String
            hist.isSelected = false
            let langRef = record[UserDefaults.History.Language] as! CKRecord.Reference
            let fetchRequestLang = NSFetchRequest<NSManagedObject>(entityName: UserDefaults.Entity.Languages)
            fetchRequestLang.predicate = NSPredicate(format: "recordName = %@", langRef.recordID.recordName)
            do {
                let result = try managedContext?.fetch(fetchRequestLang)
                let lang = result?.first as! Languages
                lang.addToHistory(hist)
            }
            catch {
                print("Error")
            }
            
            let wordRefs = record[UserDefaults.History.Words] as! Array<CKRecord.Reference>
            
            for (_, element) in wordRefs.enumerated() {
                let fetchRequestLang = NSFetchRequest<NSManagedObject>(entityName: UserDefaults.Entity.Words)
                let recordName = element.recordID.recordName as String
                fetchRequestLang.predicate = NSPredicate(format: "recordName = %@", recordName)
                do {
                    let result = try managedContext?.fetch(fetchRequestLang)
                    if result!.count > 0 {
                        let word = result?.first as! Words
                        hist.addToWords(word)
                    }
                }
                catch {
                    print("Error")
                }
            }

            return hist
        }
        catch {
            return nil
        }
    }
}
