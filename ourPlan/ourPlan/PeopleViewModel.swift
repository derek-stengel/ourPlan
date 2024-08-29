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
    @Published var people: [Person] = []
    @Published var contacts: [CNContact] = []
    
    let contactStore = CNContactStore()
    
    func fetchContacts() {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactJobTitleKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        do {
            var fetchedContacts: [CNContact] = []
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                fetchedContacts.append(contact)
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
        let job = contact.jobTitle.isEmpty ? "" : contact.jobTitle // no job title
        let phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? "No Phone Number Given"
        addPerson(name: fullName, job: job, phoneNumber: phoneNumber )
        removeContact(contact)
    }
    
    private func removeContact(_ contact: CNContact) {
        contacts.removeAll { $0.identifier == contact.identifier }
    }
    
    func addPerson(name: String, job: String, phoneNumber: String) {
        let newPerson = Person(name: name, job: job, phoneNumber: phoneNumber)
        people.append(newPerson)
    }
    
    func deletePerson(at offsets: IndexSet) {
        people.remove(atOffsets: offsets)
    }
    
    func movePerson(from source: IndexSet, to destination: Int) {
        people.move(fromOffsets: source, toOffset: destination)
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
