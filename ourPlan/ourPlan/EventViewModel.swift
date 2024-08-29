//
//  EventViewModel.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/15/24.
//

import SwiftUI
import Combine
import UIKit
import UserNotifications

class EventViewModel: ObservableObject {
//    static var shared = EventViewModel()
    
    @Published var events: [Event] = []

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


    func deleteEvent(at offsets: IndexSet) {
        events.remove(atOffsets: offsets)
    }
    
    func moveEvent(from source: IndexSet, to destination: Int) {
        events.move(fromOffsets: source, toOffset: destination)
    }
    
    func addEvent(name: String, date: Date, time: Date) {
        let newEvent = Event(name: name, date: date, time: time)
        events.append(newEvent)
        scheduleNotification(for: newEvent)
    }

    private func scheduleNotification(for event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "ourPlan"
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let formattedTime = timeFormatter.string(from: event.time)
        
        content.body = "Reminder for your \(formattedTime) alert: '\(event.name)'."
        content.sound = .default
        
        let calendar = Calendar.current
        let eventDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: event.time),
                                          minute: calendar.component(.minute, from: event.time),
                                          second: 0,
                                          of: event.date) ?? event.date
        
        let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: eventDateTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(eventDateTime)")
            }
        }
    }
}


//import Foundation
//import SwiftUI
//import Contacts
//import UserNotifications
//
//class EventViewModel: ObservableObject {
//    @Published var events: [Event] = []
//    
//    func deleteEvent(at offsets: IndexSet) {
//        events.remove(atOffsets: offsets)
//    }
//    
//    func moveEvent(from source: IndexSet, to destination: Int) {
//        events.move(fromOffsets: source, toOffset: destination)
//    }
//    
//    func addEvent(name: String, date: Date, time: Date) {
//        let newEvent = Event(name: name, date: date, time: time)
//        events.append(newEvent)
//        
//        scheduleNotification(for: newEvent)
//    }
//    
//    private func scheduleNotification(for event: Event) {
//        let content = UNMutableNotificationContent()
//        content.title = "ourPlan"
//        
//        // Format the event time using .hoursAndMinutes
//        let timeFormatter = DateFormatter()
//        timeFormatter.timeStyle = .short // This gives you hours and minutes format
//        
//        let formattedTime = timeFormatter.string(from: event.time)
//        content.body = "Reminder for your \(formattedTime) alert: '\(event.name)'."
//        content.sound = .default
//        
//        // Combine event date and time
//        let calendar = Calendar.current
//        let eventDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: event.time),
//                                          minute: calendar.component(.minute, from: event.time),
//                                          second: 0,
//                                          of: event.date) ?? event.date
//        
//        let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: eventDateTime)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//        
//        let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Failed to schedule notification: \(error.localizedDescription)")
//            } else {
//                print("Notification scheduled for \(eventDateTime)")
//            }
//        }
//    }
//}
