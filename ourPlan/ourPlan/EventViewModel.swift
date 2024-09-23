//
//  EventViewModel.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/15/24.
//

import SwiftUI
import Combine
import UserNotifications
import UIKit

class EventViewModel: ObservableObject {
    @Published var events: [Event] = [] {
        didSet {
            saveEvents()
        }
    }
    
    private let eventsKey = "savedEvents"
    
    init() {
        loadEvents()
    }
    
     // Computed property to get the next three upcoming events
        var nextThreeEvents: [Event] {
            let now = Date()
            let calendar = Calendar.current
    
            // Combine date and time for comparison
            let sortedEvents = events.filter { event in
                // Create a combined Date object with the date and time of the event
                let combinedEventDateTime = calendar.date(
                    bySettingHour: calendar.component(.hour, from: event.time),
                    minute: calendar.component(.minute, from: event.time),
                    second: 0,
                    of: event.date
                ) ?? event.date
    
                // Compare combined date-time with current date-time
                return combinedEventDateTime > now
            }
            .sorted { (event1, event2) in
                // Sort by combined date and time
                let dateTime1 = calendar.date(
                    bySettingHour: calendar.component(.hour, from: event1.time),
                    minute: calendar.component(.minute, from: event1.time),
                    second: 0,
                    of: event1.date
                ) ?? event1.date
    
                let dateTime2 = calendar.date(
                    bySettingHour: calendar.component(.hour, from: event2.time),
                    minute: calendar.component(.minute, from: event2.time),
                    second: 0,
                    of: event2.date
                ) ?? event2.date
    
                return dateTime1 < dateTime2
            }
    
            return Array(sortedEvents.prefix(3))
        }
    
    func saveEvents() {
        do {
            let data = try JSONEncoder().encode(events)
            UserDefaults.standard.set(data, forKey: eventsKey)
        } catch {
            print("Unable to encode events: \(error.localizedDescription)")
        }
    }
    
    func loadEvents() {
        guard let data = UserDefaults.standard.data(forKey: eventsKey) else { return }
        
        do {
            events = try JSONDecoder().decode([Event].self, from: data)
        } catch {
            print("Unable to decode events: \(error.localizedDescription)")
        }
    }
    
    // Rest of the methods remain unchanged
    func deleteEvent(at offsets: IndexSet) {
        events.remove(atOffsets: offsets)
        saveEvents()
    }
    
    func moveEvent(from source: IndexSet, to destination: Int) {
        events.move(fromOffsets: source, toOffset: destination)
    }
    
    // Function to update an event
    func updateEvent(_ updatedEvent: Event) {
        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
            events[index] = updatedEvent
            saveEvents()
        }
    }
    
    func addEvent(name: String, date: Date, time: Date, note: String, filter: String) {
        let newEvent = Event(name: name, date: date, time: time, note: note, filter: filter)
        events.append(newEvent)
        scheduleNotification(for: newEvent)
    }

    private func scheduleNotification(for event: Event) {
        let center = UNUserNotificationCenter.current()

        // First, check the current notification settings
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
                // If notifications are not authorized, print a message and return
                print("Notifications are not allowed.")
                return
            }

            // Prepare the content of the notification
            let content = UNMutableNotificationContent()
//            content.title = event.name
            content.body = "Reminder: \(event.name) at \(self.formatTime(event.time))"
            content.sound = UNNotificationSound.default

            // Combine the event's date and time into one Date object
            let calendar = Calendar.current
            if let combinedEventDateTime = calendar.date(
                bySettingHour: calendar.component(.hour, from: event.time),
                minute: calendar.component(.minute, from: event.time),
                second: 0,
                of: event.date
            ) {
                // Ensure the notification is set for a future date
                if combinedEventDateTime > Date() {
                    // Create the trigger for the notification
                    let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: combinedEventDateTime)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

                    // Create the request with a unique identifier using the event's UUID
                    let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)

                    // Schedule the notification
                    center.add(request) { error in
                        if let error = error {
                            print("Error scheduling notification: \(error.localizedDescription)")
                        } else {
                            print("Notification scheduled for event: \(event.name) on \(combinedEventDateTime)")
                        }
                    }
                } else {
                    print("Event time is in the past. No notification scheduled.")
                }
            } else {
                print("Failed to combine event date and time.")
            }
        }
    }

    // Helper function to format time for the notification body
    private func formatTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}

//import SwiftUI
//import Combine
//import UserNotifications
//import UIKit
//
//class EventViewModel: ObservableObject {
//    @Published var events: [Event] = [] {
//        didSet {
//            saveEvents()
//        }
//    }
//    
//    private let eventsKey = "savedEvents"
//    
//    init() {
//        loadEvents()
//    }
//    
//     // Computed property to get the next three upcoming events
//        var nextThreeEvents: [Event] {
//            let now = Date()
//            let calendar = Calendar.current
//    
//            // Combine date and time for comparison
//            let sortedEvents = events.filter { event in
//                // Create a combined Date object with the date and time of the event
//                let combinedEventDateTime = calendar.date(
//                    bySettingHour: calendar.component(.hour, from: event.time),
//                    minute: calendar.component(.minute, from: event.time),
//                    second: 0,
//                    of: event.date
//                ) ?? event.date
//    
//                // Compare combined date-time with current date-time
//                return combinedEventDateTime > now
//            }
//            .sorted { (event1, event2) in
//                // Sort by combined date and time
//                let dateTime1 = calendar.date(
//                    bySettingHour: calendar.component(.hour, from: event1.time),
//                    minute: calendar.component(.minute, from: event1.time),
//                    second: 0,
//                    of: event1.date
//                ) ?? event1.date
//    
//                let dateTime2 = calendar.date(
//                    bySettingHour: calendar.component(.hour, from: event2.time),
//                    minute: calendar.component(.minute, from: event2.time),
//                    second: 0,
//                    of: event2.date
//                ) ?? event2.date
//    
//                return dateTime1 < dateTime2
//            }
//    
//            return Array(sortedEvents.prefix(3))
//        }
//    
//    func saveEvents() {
//        do {
//            let data = try JSONEncoder().encode(events)
//            UserDefaults.standard.set(data, forKey: eventsKey)
//        } catch {
//            print("Unable to encode events: \(error.localizedDescription)")
//        }
//    }
//    
//    func loadEvents() {
//        guard let data = UserDefaults.standard.data(forKey: eventsKey) else { return }
//        
//        do {
//            events = try JSONDecoder().decode([Event].self, from: data)
//        } catch {
//            print("Unable to decode events: \(error.localizedDescription)")
//        }
//    }
//    
//    // Rest of the methods remain unchanged
//    func deleteEvent(at offsets: IndexSet) {
//        events.remove(atOffsets: offsets)
//    }
//    
//    func moveEvent(from source: IndexSet, to destination: Int) {
//        events.move(fromOffsets: source, toOffset: destination)
//    }
//    
//    // Function to update an event
//    func updateEvent(_ updatedEvent: Event) {
//        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
//            events[index] = updatedEvent
//            saveEvents()
//        }
//    }
//    
//    func addEvent(name: String, date: Date, time: Date, note: String) {
//        let newEvent = Event(name: name, date: date, time: time, note: note)
//        events.append(newEvent)
//        scheduleNotification(for: newEvent)
//    }
//
//    private func scheduleNotification(for event: Event) {
//        // Notification scheduling code
//    }
//}
