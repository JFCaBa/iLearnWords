//
//  CloudKitProtocols.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 15/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//


import Foundation
import CloudKit
import CoreData


@objc protocol CloudKitManagedObject {
    var recordID: Data? { get set }
    var recordName: String? { get set }
    var recordType: String { get }
    var lastUpdate: Date? { get set }
    
    func managedObjectToRecord() -> CKRecord
    func recordToManagedObject(_ record: CKRecord) -> NSManagedObject?
}

extension CloudKitManagedObject {
    func prepareForCloudKit() {
        let uuid = UUID()
        recordName = recordType + "." + uuid.uuidString
        let _recordID = CKRecord.ID(recordName: recordName!)
        do {
            recordID = try NSKeyedArchiver.archivedData(withRootObject: _recordID, requiringSecureCoding: false)
        }
        catch {
            print("Error")
        }
    }
    
    func cloudKitRecord() -> CKRecord {
        return CKRecord(recordType: recordType, recordID: cloudKitRecordID()!)
    }
    
    func cloudKitRecordID() -> CKRecord.ID? {
        do {
            let record = try NSKeyedUnarchiver.unarchivedObject(ofClass: CKRecord.ID.self, from: recordID!)
            return record
        }
        catch {
            return nil
        }
    }
    
    func recordsToManagedObjects(_ records: Array<CKRecord>){
        for (_, record) in records.enumerated() {
            _ = recordToManagedObject(record)
        }
    }
}
