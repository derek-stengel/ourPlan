//
//  AddEventView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/15/24.
//

import Foundation
import SwiftUI

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EventViewModel

    @State private var date = Date()
    @State private var time = Date()
    @State private var note = ""
    @State private var name = "" {
        didSet {
            if name.count > 15 {
                name = String(name.prefix(15))
            }
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Title")) {
                    TextField("15 Character Limit", text: $name)
                        .onChange(of: name) { newValue in
                            if newValue.count > 15 {
                                name = String(newValue.prefix(15))
                            }
                        }
                }
                Section(header: Text("Event Date")) {
                    DatePicker("Event Date", selection: $date, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(height: UIScreen.main.bounds.height * 0.1)
                        .padding()
                }
                Section(header: Text("Recieve an Alert")) {
                    DatePicker("Reminder", selection: $time, in: Date()..., displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                        .frame(height: UIScreen.main.bounds.height * 0.01)
                        .padding()
                }
                Section(header: Text("Note")) {
                    TextEditor(text: $note)
                        .frame(height: 150)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                }
            }
            .navigationTitle("New Event")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.addEvent(name: name, date: date, time: time, note: note)
                presentationMode.wrappedValue.dismiss()
            }
                .disabled(name.isEmpty)
            )
        }
    }
}

struct AddEventView_Preview: PreviewProvider {
    static var previews: some View {
        AddEventView(viewModel: EventViewModel())
    }
}
