//
//  Contact.swift
//  MyContactsApp
//
//  Created by Benjamin Tincher on 2/5/21.
//

import CloudKit

struct ContactStrings {
    static let nameKey = "name"
    static let phoneNumberKey = "phoneNumber"
    static let emailAddressKey = "emailAddress"
    static let recordTypeKey = "Contact"
}

class Contact {
    
    var name: String
    var phoneNumber: String?
    var emailAddress: String?
    let ckRecordID: CKRecord.ID
    
    init(name: String, phoneNumber: String?, emailAddress: String?, ckRecordID: CKRecord.ID = CKRecord.ID()) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.ckRecordID = ckRecordID
    }
}   //  End of Class

//  MARK: EXTENSIONS
extension Contact {
    
    convenience init?(ckRecord: CKRecord) {
        
        guard let name = ckRecord[ContactStrings.nameKey] as? String  else { return nil }
        
        let phoneNumber = ckRecord[ContactStrings.phoneNumberKey] as? String
            
        let emailAddress = ckRecord[ContactStrings.emailAddressKey] as? String
        
        self.init(name: name, phoneNumber: phoneNumber, emailAddress: emailAddress, ckRecordID: ckRecord.recordID)
    }
}   //  End of Extension

extension CKRecord {
    
    convenience init(contact: Contact) {
        self.init(recordType: ContactStrings.recordTypeKey, recordID: contact.ckRecordID)
        
        self.setValuesForKeys ([ ContactStrings.nameKey : contact.name ])
        
        if contact.phoneNumber != nil { setValue(contact.phoneNumber, forKey: ContactStrings.phoneNumberKey) }
        
        if contact.emailAddress != nil { setValue(contact.emailAddress, forKey: ContactStrings.emailAddressKey) }
    }
}   //  End of Extension

