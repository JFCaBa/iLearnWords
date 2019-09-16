//
//  Languages+CoreDataClass.swift
//  
//
//  Created by Jose Francisco Catalá Barba on 14/09/2019.
//
//

import Foundation
import UIKit
import CoreData
import CloudKit

class Languages: NSManagedObject, CloudKitManagedObject {
    
    var coreData = CoreDataController.shared
    
    var recordType: String { return UserDefaults.Entity.Languages }
    func managedObjectToRecord() -> CKRecord {
        guard   let title = title,
                let way = way,
                let sayOriginal = sayOriginal,
                let sayTranslated = sayTranslated
            else {
            fatalError("Required properties for record not set")
        }
        
        let record = cloudKitRecord()
        record[UserDefaults.Languages.Title]         = title as CKRecordValue
        record[UserDefaults.Languages.Way]           = way as CKRecordValue
        record[UserDefaults.Languages.IsSelected]    = isSelected as CKRecordValue
        record[UserDefaults.Languages.SayOriginal]   = sayOriginal as CKRecordValue
        record[UserDefaults.Languages.SayTranslated] = sayTranslated as CKRecordValue
//        record[UserDefaults.Languages.History]       = history as! CKRecordValue
        record[UserDefaults.Languages.LastUpdate]    = lastUpdate
        return record
    }
    
    func recordToManagedObject(_ record: CKRecord) -> NSManagedObject? {
        let managedContext = coreData.context()
        let lang = Languages(context: managedContext!)
        do {
            lang.recordID = try NSKeyedArchiver.archivedData(withRootObject: record.recordID, requiringSecureCoding: false)
            lang.recordName = record.recordID.recordName
            lang.lastUpdate = record[UserDefaults.Languages.LastUpdate]
            lang.sayOriginal = record[UserDefaults.Languages.SayOriginal] as? String
            lang.sayTranslated = record[UserDefaults.Languages.SayTranslated] as? String
            lang.title = record[UserDefaults.Languages.Title] as? String
            lang.way = record[UserDefaults.Languages.Way] as? String
            lang.isSelected = record[UserDefaults.Languages.IsSelected] as! Bool
            return lang
        }
        catch {
            return nil
        }
    }
}
