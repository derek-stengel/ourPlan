//
//  PeopleViewModel.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation
import SwiftUI
import Contacts

class PeopleViewModel: ObservableObject {
    @Published var people: [Person] = [] {
        didSet {
            savePeople()
        }
    }
    @Published var contacts: [CNContact] = []
    @Published var contactsImported: Bool = false {
        didSet {
            UserDefaults.standard.set(contactsImported, forKey: contactsImportedKey)
        }
    }
    
    private let peopleKey = "peopleKey"
    private let contactsImportedKey = "contactsImportedKey"
    let contactStore = CNContactStore()
    
    init() {
        loadPeople()
        loadContactsImportedStatus()
    }
    
    private func savePeople() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(people) {
            UserDefaults.standard.set(encoded, forKey: peopleKey)
        }
    }
    
    private func loadPeople() {
        if let savedPeople = UserDefaults.standard.data(forKey: peopleKey) {
            let decoder = JSONDecoder()
            if let loadedPeople = try? decoder.decode([Person].self, from: savedPeople) {
                self.people = loadedPeople
            }
        }
    }
    
    private func saveContactsImportedStatus() {
        UserDefaults.standard.set(true, forKey: contactsImportedKey) // Save the status
    }
    
    private func loadContactsImportedStatus() {
        contactsImported = UserDefaults.standard.bool(forKey: contactsImportedKey) // Load the status
    }
    
    func fetchContacts() {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactJobTitleKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        do {
            var fetchedContacts: [CNContact] = []
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                if !fetchedContacts.contains(where: { $0.identifier == contact.identifier }) {
                    fetchedContacts.append(contact)
                }
            }
            DispatchQueue.main.async {
                self.contacts = fetchedContacts
            }
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
    }
    
    func addPersonFromContact(_ contact: CNContact) {
        let fullName = "\(contact.givenName) \(contact.familyName)"
        let job = contact.jobTitle.isEmpty ? "" : contact.jobTitle
        let phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? "No Phone Number Given"
        let email = contact.emailAddresses.first?.value as String? ?? "No Email Provided"
        var address = "No address found"
        if let postalAddress = contact.postalAddresses.first?.value {
            let street = postalAddress.street
            let city = postalAddress.city
            let state = postalAddress.state
            let postalCode = postalAddress.postalCode
            address = "\(street), \(city), \(state) \(postalCode)"
        }
        
        addPerson(name: fullName, job: job, phoneNumber: phoneNumber, email: email, address: address)
        removeContact(contact)
    }
    
    func removeContact(_ contact: CNContact) {
        contacts.removeAll { $0.identifier == contact.identifier }
    }
    
    func addPerson(name: String, job: String, phoneNumber: String, email: String, address: String) {
        let newPerson = Person(name: name, job: job, phoneNumber: phoneNumber, email: email, address: address)
        people.append(newPerson)
        contactsImported = true
        saveContactsImportedStatus()
    }
    
    func deletePerson(by uuidString: String) {
        if let index = people.firstIndex(where: { $0.id == uuidString }) {
            people.remove(at: index)
            savePeople()
        }
    }
    
    func requestContactsAccess() {
        contactStore.requestAccess(for: .contacts) { granted, error in
            if granted {
                self.fetchContacts()
            } else {
                print("Contacts access denied")
            }
        }
    }
}
