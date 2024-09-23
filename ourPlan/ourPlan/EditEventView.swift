//
//  EditEventView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/15/24.
//

import SwiftUI

struct EditEventView: View {
    @Binding var event: Event
    @Binding var selectedColor: UIColor
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedFilter: String = "" // To keep track of the selected filter
    
    var body: some View {
        Form {
            Section(header: Text("Event Title")) {
                TextField("Enter New Event Title", text: $event.name)
                    .onChange(of: event.name) { newValue in
                        
                        if newValue.count > 15 {
                            event.name = String(newValue.prefix(15))
                        } else {
                            event.name = newValue
                        }
                    }
            }
            
            Section(header: Text("Event Date")) {
                DatePicker("Event Date", selection: $event.date, in: Date()..., displayedComponents: .date)
                    .frame(width: 310, height: 8)
                    .padding()
            }
            
            Section(header: Text("Reminder Time")) {
                DatePicker("Reminder set for", selection: $event.time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(CompactDatePickerStyle())
                    .frame(width: 310, height: 8)
                    .padding()
            }
            
            Section(header: Text("Filter")) {
                Menu {
                    // Show filter options
                    ForEach(Event.defaultFilters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                            event.filter = filter
                        }) {
                            Text(filter)
                        }
                    }
                } label: {
                    // Current filter selection as label
                    HStack {
                        Spacer() // Add spacer to push the content to the center
                        Text(selectedFilter) // Show the current event filter
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer() // Add spacer after the text
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color(selectedColor))
                            .frame(width: 20, height: 20)
                    }
                    .frame(height: 20)
                    .padding(.vertical, 5)
                }
            }
            
            Section(header: Text("Note")) {
                TextEditor(text: $event.note)
                    .frame(height: 150)
                    .onChange(of: event.note) { newValue in
                        event.note = newValue
                    }
            }
        }
            Button(action: {
                dismiss()
            }) {
                Text("Save Changes")
                    .font(.system(size: 22, design: .serif))
                    .foregroundColor(Color(selectedColor)) // Ensure the text contrasts with the background
                    .bold()
                    .frame(maxWidth: .infinity)
                    
            }
            
        
        
        .navigationTitle("Edit Event")
    }
}

struct EditEventView_Previews: PreviewProvider {
    @State static var event: Event = Event(name: "Nothing interesting", date: Date(), time: Date(), note: "Nothing to see here", filter: "No filter")
    @State static var selectedColor: UIColor = .systemCyan
    
    static var previews: some View {
        EditEventView(event: $event, selectedColor: $selectedColor)
    }
}

//
//struct EditEventView: View {
//    @Binding var event: Event
//    @Binding var selectedColor: UIColor
//    @Environment(\.presentationMode) var presentationMode
//
//    @State private var selectedFilter: String = "" // To keep track of the selected filter
//
//    var body: some View {
//        Form {
//            Section(header: Text("Event Title")) {
//                TextField("Enter New Event Title", text: $event.name)
//                    .onChange(of: event.name) { newValue in
//                        // Ensure that the value updates immediately
//                        event.name = newValue
//                    }
//            }
//
//            Section(header: Text("Event Date")) {
//                DatePicker("Event Date", selection: $event.date, in: Date()..., displayedComponents: .date)
//                    .frame(width: 310, height: 8)
//                    .padding()
//            }
//
//            Section(header: Text("Reminder Time")) {
//                DatePicker("Reminder set for", selection: $event.time, displayedComponents: .hourAndMinute)
//                    .datePickerStyle(CompactDatePickerStyle())
//                    .frame(width: 310, height: 8)
//                    .padding()
//            }
//
//            Section(header: Text("Filter")) {
//                Menu {
//                    // Show filter options
//                    ForEach(Event.defaultFilters, id: \.self) { filter in
//                        Button(action: {
//                            selectedFilter = filter
//                            event.filter = filter // Update the event filter directly
//                        }) {
//                            Text(filter)
//                        }
//                    }
//                } label: {
//                    // Current filter selection as label
//                    HStack {
//                        Spacer() // Add spacer to push the content to the center
//                        Text(event.filter) // Show the current event filter
//                            .frame(maxWidth: .infinity, alignment: .center)
//                        Spacer() // Add spacer after the text
//                        Image(systemName: "chevron.down")
//                            .foregroundColor(Color(selectedColor))
//                            .frame(width: 20, height: 20)
//                    }
//                    .frame(height: 20)
//                    .padding(.vertical, 5)
//                }
//            }
//
//            Section(header: Text("Note")) {
//                TextEditor(text: $event.note)
//                    .frame(height: 150)
//                    .onChange(of: event.note) { newValue in
//                        event.note = newValue
//                    }
//            }
//        }
//        .navigationTitle("Edit Event")
//        .navigationBarItems(trailing: Button("Done") {
//            presentationMode.wrappedValue.dismiss()
//        })
//    }
//}
//
//struct EditEventView_Previews: PreviewProvider {
//    @State static var event: Event = Event(name: "Nothing interesting", date: Date(), time: Date(), note: "Nothing to see here", filter: "No filter")
//    @State static var selectedColor: UIColor = .systemCyan
//
//    static var previews: some View {
//        EditEventView(event: $event, selectedColor: $selectedColor)
//    }
//}
