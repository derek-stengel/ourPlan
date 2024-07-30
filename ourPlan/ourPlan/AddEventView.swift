//
//  AddEventView.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PeopleViewModel

    @State private var title = ""
    @State private var date: Date

    init(viewModel: PeopleViewModel, date: Date = Date()) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _date = State(initialValue: date)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Event Title", text: $title)
                }
                Section(header: Text("Date")) {
                    DatePicker("Event Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Event")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.addEvent(title: title, date: date)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


