//
//  ContactError.swift
//  MyContactsApp
//
//  Created by Benjamin Tincher on 2/5/21.
//

import Foundation

enum ContactError: LocalizedError {
    case recordError
    case unableToUnwrap
    case ckError(Error)
    
    var errorDescription: String? {
        switch self {
        case .recordError:
            return "Unable to retrieve record."
        case .unableToUnwrap:
            return "Unable to unwrap optional record"
        case .ckError(let error):
            return error.localizedDescription
        }
    }
}
