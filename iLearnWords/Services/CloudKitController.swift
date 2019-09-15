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
    
    // Represents the default container specified in the iCloud section of the Capabilities tab for the project.
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    public var fetchCompletion: ((Array<Any>?) -> Void)? = nil
//    public var saveCompletion: ((Any?) -> Void)? = nil
    
    // MARK: - Initializers
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    // MARK: - Fetch
    func fetchLanguages(_ contextManager: NSManagedObjectContext) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Languages", predicate: predicate)
        var retArray: Array<Languages> = []
        privateDB.perform(query, inZoneWith: nil) { records, error in
            guard let languages = records else { return }
            //Iterate the records..
            for (_ ,element) in (languages.enumerated()) {
                DispatchQueue.main.async {
                    let lang = Languages(context: contextManager)
                    let managed = lang.recordToManagedObject(element) as! Languages
                    retArray.append(managed)
                }
            }
            self.fetchCompletion?(retArray)
        }
    }
    
    func fetchHistory(_ contextManager: NSManagedObjectContext) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "History", predicate: predicate)
        var retArray: Array<History> = []
        privateDB.perform(query, inZoneWith: nil) { records, error in
            guard let history = records else { return }
            //Iterate the records..
            for (_ ,element) in (history.enumerated()) {
                DispatchQueue.main.async {
                    let hist = History(context: contextManager)
                    let managed = hist.recordToManagedObject(element) as! History
                    retArray.append(managed)
                }
            }
            self.fetchCompletion?(retArray)
        }
    }
    
    func fetchWords(_ contextManager: NSManagedObjectContext) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Words", predicate: predicate)
        var retArray: Array<Words> = []
        privateDB.perform(query, inZoneWith: nil) { records, error in
            guard let words = records else { return }
            //Iterate the records..
            for (_ ,element) in (words.enumerated()) {
                DispatchQueue.main.async {
                    let word = Words(context: contextManager)
                    let managed = word.recordToManagedObject(element) as! Words
                    retArray.append(managed)
                }
            }
            self.fetchCompletion?(retArray)
        }
    }
    
    // MARK: - Save
    func saveHistory(_ hist: History, managedContext: NSManagedObjectContext) {
        do {
            let cKhistory = CKRecord(recordType: "History")
            let langID = try NSKeyedUnarchiver.unarchivedObject(ofClass: CKRecord.ID.self, from: hist.language!.recordID!)
            let refLang = CKRecord.Reference(recordID: langID!, action: .deleteSelf)
            cKhistory.setValue(refLang, forKey: "language")
           // let histID = try NSKeyedUnarchiver.unarchivedObject(ofClass: CKRecord.ID.self, from: hist.recordID!)
            let histRef = CKRecord.Reference(record: cKhistory, action: .deleteSelf)
            var wordsRecords: Array<CKRecord> = []
            for (_, element) in (hist.words?.enumerated())! {
                let word = element as! Words
                let ckRecord = toRecord(word)
                ckRecord.setValue(histRef, forKey: "history")
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
            
            cKhistory.setValue(wordsReferences, forKey: "words")
            cKhistory.setValue(hist.title, forKey: "title")
            cKhistory.setValue(hist.isSelected, forKey: "isSelected")
            
            self.privateDB.save(cKhistory) { (record, error) in
                do {
                    hist.recordID = try NSKeyedArchiver.archivedData(withRootObject: record!.recordID, requiringSecureCoding: false)
                    hist.recordName = record!.recordID.recordName
                    hist.lastUpdate = record?.modificationDate
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
    
    func saveCkWord(_ word: Words, managedContext: NSManagedObjectContext) {
        let ckWord = CKRecord(recordType: "Words")
        ckWord.setValue(word.original, forKey: "original")
        ckWord.setValue(word.translated, forKey: "translated")
        publicDB.save(ckWord) { (record, error) in
            do {
                word.lastUpdate = record?.modificationDate
                try managedContext.save()
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
