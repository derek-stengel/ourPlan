//
//  Person.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation
import SwiftUI
import Contacts

struct Person: Identifiable {
    let id = UUID()
    var name: String
    var job: String
    var phoneNumber: String
}

struct Contact: Identifiable {
    let id: String
    let fullName: String
    let jobTitle: String
    let phoneNumber: String
    
    init(contact: CNContact) {
        self.id = contact.identifier
        self.fullName = "\(contact.givenName) \(contact.familyName)"
        self.jobTitle = contact.jobTitle
        
        // safely extract first phone number, if there is one
        if let firstPhoneNumber = contact.phoneNumbers.first?.value.stringValue {
            self.phoneNumber = firstPhoneNumber
        } else {
            self.phoneNumber = "No phone number Given"
        }
    }
}
