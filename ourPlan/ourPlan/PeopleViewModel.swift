//
//  PeopleViewModel.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation
import SwiftUI

class PeopleViewModel: ObservableObject {
    @Published var people: [Person] = []
    @Published var events: [Event] = []

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
}
