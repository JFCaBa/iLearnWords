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
            //Use the records..
            
            for (_ ,element) in (languages.enumerated()) {
                let lang = Languages(context: contextManager)
                do {
                    lang.recordID = try NSKeyedArchiver.archivedData(withRootObject: element.recordID, requiringSecureCoding: false)
                    lang.recordName = element.recordID.recordName
                    lang.sayOriginal = element["sayOriginal"] as? String
                    lang.sayTranslated = element["sayTranslated"] as? String
                    lang.title = element["title"] as? String
                    lang.way = element["way"] as? String
                    lang.lastUpdate = element["modificationDate"] as? Date
                    lang.isSelected = element["isSelected"] as! Bool
                    retArray.append(lang)
                }
                catch {
                    print("Error fetching languages from CloudKit")
                }
            }
            self.fetchCompletion?(retArray)
        }
    }
    
    func fetchHistory(_ contextManager: NSManagedObjectContext) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Languages", predicate: predicate)
        var retArray: Array<History> = []
        privateDB.perform(query, inZoneWith: nil) { records, error in
            guard let history = records else { return }
            //Use the records..
            for (_ ,element) in (history.enumerated()) {
                let hist = History(context: contextManager)
                do {
                    hist.recordID = try NSKeyedArchiver.archivedData(withRootObject: element.recordID, requiringSecureCoding: false)
                    hist.recordName = element.recordID.recordName
                    hist.language = element["language"] as? Languages
                    hist.words = element["words"] as? NSSet
                    hist.title = element["title"] as? String
                    hist.lastUpdate = element["modificationDate"] as? Date
                    hist.isSelected = element["isSelected"] as! Bool
                    retArray.append(hist)
                }
                catch {
                    print("Error fetching languages from CloudKit")
                }
            }
            self.fetchCompletion?(retArray)
        }
    }
    
    func fetchWords(_ contextManager: NSManagedObjectContext) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Languages", predicate: predicate)
        var retArray: Array<Words> = []
        privateDB.perform(query, inZoneWith: nil) { records, error in
            guard let words = records else { return }
            //Use the records..
            for (_ ,element) in (words.enumerated()) {
                let word = Words(context: contextManager)
                do {
                    word.recordID = try NSKeyedArchiver.archivedData(withRootObject: element.recordID, requiringSecureCoding: false)
                    word.recordName = element.recordID.recordName
                    word.original = element["original"] as? String
                    word.translated = element["translated"] as? String
                    word.history = element["history"] as? History
                    word.lastUpdate = element["modificationDate"] as? Date
                    retArray.append(word)
                }
                catch {
                    print("Error fetching languages from CloudKit")
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
            let refHist = CKRecord.Reference(recordID: langID!, action: .deleteSelf)
            cKhistory.setValue(refHist, forKey: "language")
            
            var wordsRecords: Array<CKRecord> = []
            for (_, element) in (hist.words?.enumerated())! {
                let word = element as! Words
                let ckRecord = toRecord(word)
                self.privateDB.save(ckRecord) { (record, error) in
                    do {
                        word.recordID = try NSKeyedArchiver.archivedData(withRootObject: record!.recordID, requiringSecureCoding: false)
                        word.recordName = record!.recordID.recordName
                        word.lastUpdate = record?.modificationDate
//                        try managedContext.save()
                    }
                    catch {
                        print("Error Saving History to CloudKit")
                    }
                }
                wordsRecords.append(ckRecord)
            }
            
            var wordsReferences: Array<CKRecord.Reference> = []
            for (_, element) in wordsRecords.enumerated() {
                let reference = CKRecord.Reference(record: element, action: .deleteSelf)
                wordsReferences.append(reference)
            }
            
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
    
    func saveWords(_ word: Words, managedContext: NSManagedObjectContext) {
        let ckWord = CKRecord(recordType: "Words")
        ckWord.setValue(word.original, forKey: "original")
        ckWord.setValue(word.translated, forKey: "translated")
        //ckWord.setValue(word.history, forKey: "history")
        publicDB.save(ckWord) { (record, error) in
            do {
                word.recordID = try NSKeyedArchiver.archivedData(withRootObject: record!.recordID, requiringSecureCoding: false)
                word.recordName = record!.recordID.recordName
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
}
