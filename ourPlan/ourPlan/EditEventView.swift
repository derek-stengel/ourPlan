//
//  EditEventView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/15/24.
//

import Foundation
import SwiftUI
import Contacts

struct EditEventView: View {
    @Binding var event: Event

    var body: some View {
        Form {
            Section(header: Text("Event Title")) {
                TextField("Enter New Event Title", text: $event.name)
                    .onChange(of: event.name) { newValue in
                        // Ensure that the value updates immediately
                        event.name = newValue
                    }
            }
            Section(header: Text("Event Date")) {
                DatePicker("Event Date", selection: $event.date, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .frame(height: UIScreen.main.bounds.height * 0.1)
                    .padding()
            }
            Section(header: Text("Reminder")) {
                DatePicker("Reminder set for", selection: $event.time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(CompactDatePickerStyle())
                    .frame(height: UIScreen.main.bounds.height * 0.01)
                    .padding()
            }
            Section(header: Text("Note")) {
                TextField("Write a note...", text: $event.note)
                    .frame(height: 150)
                    .onChange(of: event.note) { newValue in
                        // Ensure that the value updates immediately
                        event.note = newValue
                    }
            }
        }
        .navigationTitle("Edit Event")
    }
}

//struct EditEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEventView(event: Event(name: "", date: 12/29/02, time: <#T##Date#>, note: <#T##String#>)
//    }
//}
