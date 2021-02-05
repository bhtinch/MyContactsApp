//
//  ContactController.swift
//  MyContactsApp
//
//  Created by Benjamin Tincher on 2/5/21.
//

import CloudKit

class ContactController {
    
    //  MARK: PROPERTIES
    static let shared = ContactController()
    
    var contacts: [Contact] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //  MARK: METHODS
    func createContactWith(name: String, phoneNumber: String?, emailAddress: String?, completion: @escaping (Result<String, ContactError>) -> Void) {
        
        let contact = Contact(name: name, phoneNumber: phoneNumber, emailAddress: emailAddress)
        let contactRecord = CKRecord(contact: contact)
        
        privateDB.save(contactRecord) { (recored, error) in
            if let error = error {
                print("***Error Saving Record to iCloud*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = recored,
                  let contact = Contact(ckRecord: record) else { return completion(.failure(.recordError)) }
            
            self.contacts.append(contact)
            completion(.success("Contact created successfully."))
        }
    }
    
    func fetchAllContacts(completion: @escaping (Result<String, ContactError>) -> Void) {
        
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactStrings.recordTypeKey, predicate: fetchAllPredicate)
        
        self.privateDB.perform(query , inZoneWith: nil) { (records, error) in
            if let error = error {
                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.recordError)) }
            
            let fetchedContacts = records.compactMap { Contact(ckRecord: $0) }
            self.contacts = fetchedContacts
            completion(.success("Contacts fetched successfully."))
        }
    }
    
    func update(contact: Contact, completion: @escaping (Result<String, ContactError>) -> Void) {
        
        let record = CKRecord(contact: contact)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.qualityOfService = .userInteractive
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { records, recordIDs, error in
            
            if let error = error {
                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first else { return completion(.failure(.recordError)) }
            
            completion(.success("Successfully updated contact with record ID: \(record.recordID.recordName)"))
        }
        privateDB.add(operation)
    }
    
    func delete(contact: Contact, index: Int, completion: @escaping (Result<String, ContactError>) -> Void) {
               
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [contact.ckRecordID])
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, recordIDs, error in
            
            if let error = error {
                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let recordID = recordIDs?.first else { return completion(.failure(.recordError)) }
            
            completion(.success("Successfully deleted record with ID: \(recordID)"))
        }
        contacts.remove(at: index)
        privateDB.add(operation)
    }
}   //  End of Class
