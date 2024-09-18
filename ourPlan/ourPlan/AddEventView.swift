//
//  AddEventView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/15/24.
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EventViewModel
    
    @Binding var selectedColor: UIColor
    @State private var showingCustomFilterSheet = false // To show the custom filter input view
    @State private var selectedFilter: String = Event.defaultFilters.first! // Default selection
    @State private var customFilter = ""
    
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
                    DatePicker("Event Date", selection: $date, displayedComponents: .date)
                        .frame(width: 310, height: 40)
                }
                
                Section(header: Text("Reminder Time")) {
                    DatePicker("Reminder", selection: $time, displayedComponents: .hourAndMinute)
                        .frame(width: 310, height: 40)
                }
                
                Section(header: Text("Filter")) {
                    Menu {
                        // Show filter options
                        ForEach(Event.defaultFilters, id: \.self) { filter in
                            Button(action: {
                                selectedFilter = filter
                                customFilter = ""
                            }) {
                                Text(filter)
                            }
                        }
                        Button(action: {
                            showingCustomFilterSheet.toggle()
                        }) {
                            Text("Create Custom Filter")
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(selectedFilter)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color(selectedColor))
                                .frame(width: 20, height: 20)
                        }
                        .frame(height: 20)
                        .padding(.vertical, 5)
                    }
                }
                
                Section(header: Text("Note")) {
                    TextEditor(text: $note)
                        .frame(height: 150)
                }
            }
            .navigationTitle("New Event")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.addEvent(name: name, date: date, time: time, note: note, filter: selectedFilter)
                presentationMode.wrappedValue.dismiss()
            }
                .disabled(name.isEmpty)
            )
            .sheet(isPresented: $showingCustomFilterSheet) {
                CreateCustomFilterView(selectedFilter: $selectedFilter, showingCustomFilterSheet: $showingCustomFilterSheet, selectedColor: $selectedColor)
            }
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(viewModel: EventViewModel(), selectedColor: .constant(.red))
    }
}




////
////  AddEventView.swift
////  ourPlan
////
////  Created by Derek Stengel on 8/15/24.
////
//
//import Foundation
//import SwiftUI
//
//struct AddEventView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var viewModel: EventViewModel
//
//    @State private var date = Date()
//    @State private var time = Date()
//    @State private var selectedFilter: String = Event.defaultFilters.first! // Default selection
//    @State private var note = ""
//    @State private var name = "" {
//        didSet {
//            if name.count > 15 {
//                name = String(name.prefix(15))
//            }
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Event Title")) {
//                    TextField("15 Character Limit", text: $name)
//                        .onChange(of: name) { newValue in
//                            if newValue.count > 15 {
//                                name = String(newValue.prefix(15))
//                            }
//                        }
//                }
//                Section(header: Text("Event Date")) {
//                    DatePicker("Event Date", selection: $date, displayedComponents: .date)
//                        .datePickerStyle(WheelDatePickerStyle())
//                        .frame(height: UIScreen.main.bounds.height * 0.1)
//                        .padding()
//                }
//                Section(header: Text("Recieve an Alert")) {
//                    DatePicker("Reminder", selection: $time, displayedComponents: .hourAndMinute)
//                        .datePickerStyle(CompactDatePickerStyle())
//                        .frame(height: UIScreen.main.bounds.height * 0.01)
//                        .padding()
//                }
//                Section(header: Text("Note")) {
//                    TextEditor(text: $note)
//                        .frame(height: 150)
//                        .background(Color(UIColor.secondarySystemBackground))
//                        .cornerRadius(10)
//                }
//            }
//            .navigationTitle("New Event")
//            .navigationBarItems(leading: Button("Cancel") {
//                presentationMode.wrappedValue.dismiss()
//            }, trailing: Button("Save") {
//                viewModel.addEvent(name: name, date: date, time: time, note: note)
//                presentationMode.wrappedValue.dismiss()
//            }
//                .disabled(name.isEmpty)
//            )
//        }
//    }
//}
//
//struct AddEventView_Preview: PreviewProvider {
//    static var previews: some View {
//        AddEventView(viewModel: EventViewModel())
//    }
//}
