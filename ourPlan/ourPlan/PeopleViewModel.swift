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
    @Published var events: [Event] = []
    @Published var contacts: [CNContact] = []
    
    let contactStore = CNContactStore()
    
    func fetchContacts() {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactJobTitleKey]
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
        let job = contact.jobTitle.isEmpty ? "No job title" : contact.jobTitle
        addPerson(name: fullName, job: job)
        removeContact(contact)
    }
    
    private func removeContact(_ contact: CNContact) {
        contacts.removeAll { $0.identifier == contact.identifier }
    }
    
    func addPerson(name: String, job: String) {
        let newPerson = Person(name: name, job: job)
        people.append(newPerson)
    }
    
    func deletePerson(at offsets: IndexSet) {
        people.remove(atOffsets: offsets)
    }
    
    func movePerson(from source: IndexSet, to destination: Int) {
        people.move(fromOffsets: source, toOffset: destination)
    }
    
    func addEvent(title: String, date: Date) {
        let newEvent = Event(title: title, date: date)
        events.append(newEvent)
    }
    
    func deleteEvent(at offsets: IndexSet) {
        events.remove(atOffsets: offsets)
    }
    
    func events(for date: Date) -> [Event] {
        let calendar = Calendar.current
        return events.filter { calendar.isDate($0.date, inSameDayAs: date) }
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


//class PeopleViewModel: ObservableObject {
//    @Published var people: [Person] = []
//    @Published var events: [Event] = []
//    @Published var contacts: [CNContact] = []
//    
//    let contactStore = CNContactStore()
//    
//    func fetchContacts() {
//        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactJobTitleKey]
//        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
//        
//        do {
//            var fetchedContacts: [CNContact] = []
//            try contactStore.enumerateContacts(with: request) { (contact, stop) in
//                fetchedContacts.append(contact)
//            }
//            DispatchQueue.main.async {
//                self.contacts = fetchedContacts
//            }
//        } catch {
//            print("Failed to fetch contacts: \(error)")
//        }
//    }
//    
//    func addPersonFromContact(_ contact: CNContact) {
//        let fullName = "\(contact.givenName) \(contact.familyName)"
//        let job = contact.jobTitle.isEmpty ? "No job title" : contact.jobTitle
//        addPerson(name: fullName, job: job)
//    }
//    
//    func addPerson(name: String, job: String) {
//        let newPerson = Person(name: name, job: job)
//        people.append(newPerson)
//    }
//    
//    func deletePerson(at offsets: IndexSet) {
//        people.remove(atOffsets: offsets)
//    }
//    
//    func movePerson(from source: IndexSet, to destination: Int) {
//        people.move(fromOffsets: source, toOffset: destination)
//    }
//    
//    func addEvent(title: String, date: Date) {
//        let newEvent = Event(title: title, date: date)
//        events.append(newEvent)
//    }
//    
//    func deleteEvent(at offsets: IndexSet) {
//        events.remove(atOffsets: offsets)
//    }
//    
//    func events(for date: Date) -> [Event] {
//        let calendar = Calendar.current
//        return events.filter { calendar.isDate($0.date, inSameDayAs: date) }
//    }
//    
//    func requestContactsAccess() {
//        contactStore.requestAccess(for: .contacts) { granted, error in
//            if granted {
//                self.fetchContacts()
//            } else {
//                print("Contacts access denied")
//            }
//        }
//    }
//}
