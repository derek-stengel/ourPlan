//
//  Person.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation
import SwiftUI
import Contacts

struct Person: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var job: String
    var phoneNumber: String
    var email: String
    var address: String
    var isSelected: Bool = false
}

struct Contact: Identifiable {
    let id: String
    let fullName: String
    let jobTitle: String
    let phoneNumber: String
    let address: String
    
    init(contact: CNContact) {
        self.id = contact.identifier
        self.fullName = "\(contact.givenName) \(contact.familyName)"
        self.jobTitle = contact.jobTitle
        
        if let firstPhoneNumber = contact.phoneNumbers.first?.value.stringValue {
            self.phoneNumber = firstPhoneNumber
        } else {
            self.phoneNumber = "No phone number given"
        }
        
        if let firstAddress = contact.postalAddresses.first?.value {
            let street = firstAddress.street
            let city = firstAddress.city
            let state = firstAddress.state
            let postalCode = firstAddress.postalCode
            self.address = "\(street), \(city), \(state) \(postalCode)"
        } else {
            self.address = "No address given"
        }
    }
}
