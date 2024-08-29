//
//  AddPersonView.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation
import SwiftUI
import Contacts

struct AddPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PeopleViewModel

    @State private var name = ""
    @State private var job = ""
    @State private var phoneNumber = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $name)
                }
                Section(header: Text("Job")) {
                    TextField("Job", text: $job)
                }
                Section(header: Text("Phone Number")) {
                    TextField("Phone Number", text: $phoneNumber)
                }
            }
            .navigationTitle("Add Person")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.addPerson(name: name, job: job, phoneNumber: phoneNumber)
                presentationMode.wrappedValue.dismiss()
            }
                .disabled(name.isEmpty)
            )
        }
    }
}
