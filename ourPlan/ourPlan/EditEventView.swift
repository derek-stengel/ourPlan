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
            }
            Section(header: Text("Event Date")) {
                DatePicker("Event Date", selection: $event.date, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .frame(height: UIScreen.main.bounds.height * 0.1)
                    .padding()
            }
            Section(header: Text("Event Time")) {
                DatePicker("Event Time", selection: $event.time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(CompactDatePickerStyle())
                    .frame(height: UIScreen.main.bounds.height * 0.01)
                    .padding()
            }
        }
        .navigationTitle("Edit Event")
    }
}

//struct EditEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEventView(event: Event($name: "", $date: Date(), $time: Date()))
//    }
//}
