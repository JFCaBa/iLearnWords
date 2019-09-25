//
//  CloudKitController.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 13/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

protocol RecordHelper {
    func toRecord(_ sender: Words) -> CKRecord
}

class CloudKitController {
    
    static let shared = CloudKitController()
    
    // Represents the default container specified in the iCloud section of the Capabilities tab for the project.
    let container: CKContainer = CKContainer.default()
    let privateDB: CKDatabase
    
    public var fetchCompletion: ((Array<Any>?) -> Void)? = nil
    public var synchronizeCompletion: ((Error?) -> Void)? = nil
    
    // MARK: - Initializers
    init() {
        privateDB = container.privateCloudDatabase
    }
    
    /** NEW APPROACH */
    func synchronizeWith(new:[Any], update:[Any], delete:[Any], completionHandler:(Error?) -> Void) {
        
    }
    
    // MARK: - Fetch
    func fetchLanguages(completionHandler:@escaping (Array<Any>?) -> Void?) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Languages", predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { records, error in
            guard let recordsArray = records else {
                completionHandler(nil)
                return
            }
            completionHandler(recordsArray)
        }
    }
    
    func fetchHistory(completionHandler:@escaping (Array<Any>?) -> Void?) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "History", predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { records, error in
            guard let recordsArray = records else {
                completionHandler(nil)
                return
            }
            completionHandler(recordsArray)
        }
    }
    
    func fetchWords(completionHandler:@escaping (Array<Any>?) -> Void?) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Words", predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { records, error in
            guard let recordsArray = records else {
                completionHandler(nil)
                return
            }
            completionHandler(recordsArray)
        }
    }
    
    // MARK: - Save
    func saveCkHistory(_ hist: History, managedContext: NSManagedObjectContext) {
        do {
            let cKhistory = CKRecord(recordType: UserDefaults.Entity.History)
            let langID = try NSKeyedUnarchiver.unarchivedObject(ofClass: CKRecord.ID.self, from: hist.language!.recordID!)
            let refLang = CKRecord.Reference(recordID: langID!, action: .deleteSelf)
            cKhistory.setValue(refLang, forKey: UserDefaults.History.Language)
           // let histID = try NSKeyedUnarchiver.unarchivedObject(ofClass: CKRecord.ID.self, from: hist.recordID!)
            let histRef = CKRecord.Reference(record: cKhistory, action: .deleteSelf)
            var wordsRecords: Array<CKRecord> = []
            for (_, element) in (hist.words?.enumerated())! {
                let word = element as! Words
                let ckRecord = toRecord(word)
                ckRecord.setValue(histRef, forKey: UserDefaults.Languages.History)
                self.privateDB.save(ckRecord) { (record, error) in
                    do {
                        word.recordID = try NSKeyedArchiver.archivedData(withRootObject: record!.recordID, requiringSecureCoding: false)
                        word.recordName = record!.recordID.recordName
                        word.lastUpdate = record?.modificationDate
                    }
                    catch {
                        print("Error Saving History to CloudKit")
                    }
                }
                wordsRecords.append(ckRecord)
            }
            
            let wordsReferences = toArrayOfReferences(wordsRecords)
            
            cKhistory.setValue(wordsReferences, forKey: UserDefaults.History.Words)
            cKhistory.setValue(hist.title, forKey: UserDefaults.History.Title)
            cKhistory.setValue(hist.isSelected, forKey: UserDefaults.History.IsSelected)
            
            self.privateDB.save(cKhistory) { (record, error) in
                guard let ckRecord = record else {return}
                do {
                    hist.recordID = try NSKeyedArchiver.archivedData(withRootObject: ckRecord.recordID, requiringSecureCoding: false)
                    hist.recordName = ckRecord.recordID.recordName
                    hist.lastUpdate = ckRecord.modificationDate
                    try managedContext.save()
                }
                catch {
                    print("Error Saving History to CloudKit")
                }
            }
        }
        catch{
            print ("Error")
        }
    }
    
    func saveCkWord(_ word: Words) {
        do {
            let recordID = try NSKeyedUnarchiver.unarchivedObject(ofClass: CKRecord.ID.self, from: word.recordID!)
            privateDB.fetch(withRecordID: recordID!) { (record, error) in
                if let ckWord = record {
                    ckWord.setObject(word.translated as __CKRecordObjCValue?, forKey: UserDefaults.Words.Translated)
                    let modifyRecords = CKModifyRecordsOperation(recordsToSave:[ckWord], recordIDsToDelete: nil)
                    modifyRecords.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.allKeys
                    modifyRecords.qualityOfService = QualityOfService.userInitiated
                    modifyRecords.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
                        if error == nil {
                            word.lastUpdate = Date()
                            print("Modified")
                        }else {
                            print(error as Any)
                        }
                    }
                    self.privateDB.add(modifyRecords)
                }
            }
        }
        catch {
            print("Error")
        }
    }
    
    func saveCkLanguage(_ language: Languages) {
        let record = language.cloudKitRecord()
        record.setValue(language.isSelected, forKey: UserDefaults.Languages.IsSelected)
        record.setValue(Date(), forKey: UserDefaults.Languages.LastUpdate)
        record.setValue(language.sayOriginal, forKey: UserDefaults.Languages.SayOriginal)
        record.setValue(language.sayTranslated, forKey: UserDefaults.Languages.SayTranslated)
        record.setValue(language.way, forKey: UserDefaults.Languages.Way)
        
        self.privateDB.save(record) { (record, error) in
            do {
                language.recordID = try NSKeyedArchiver.archivedData(withRootObject: record!.recordID, requiringSecureCoding: false)
                language.recordName = record!.recordID.recordName
                language.lastUpdate = Date()
            }
            catch {
                print("Error Saving History to CloudKit")
            }
        }
    }
}

extension CloudKitController {
    
    func toRecord(_ sender: Words) -> CKRecord {
        let ckRecord = CKRecord(recordType: "Words")
        ckRecord.setValue(sender.original, forKey: "original")
        ckRecord.setValue(sender.translated, forKey: "translated")
        return ckRecord
    }
    
    func toArrayOfRecords(_ sender: Array<Words>) -> Array<CKRecord> {
        var records: Array<CKRecord> = []
        for (_, element) in sender.enumerated() {
            let record = toRecord(element)
            records.append(record)
        }
        return records
    }
    
    func toArrayOfReferences(_ sender: Array<CKRecord>) -> Array<CKRecord.Reference> {
        var references: Array<CKRecord.Reference> = []
        for (_, element) in sender.enumerated() {
            let reference = CKRecord.Reference(record: element, action: .deleteSelf)
            references.append(reference)
        }
        return references
    }
}
