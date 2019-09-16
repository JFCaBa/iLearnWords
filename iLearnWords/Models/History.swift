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
        record[UserDefaults.Languages.LastUpdate]   = lastUpdate
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
            hist.isSelected = record[UserDefaults.Languages.IsSelected] as! Bool
            return hist
        }
        catch {
            return nil
        }
    }
    
    func addLanguageToHistory(_ History: NSManagedObject) {
        
    }
}
