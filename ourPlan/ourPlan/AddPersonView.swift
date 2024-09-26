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
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PeopleViewModel

    @State private var name = ""
    @State private var job = ""
    @State private var phoneNumber = ""
    @State private var email = ""

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
                Section(header: Text("Email")) {
                    TextField("Email Address", text: $email)
                }
            }
            .navigationTitle("Add Person")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Save") {
                viewModel.addPerson(name: name, job: job, phoneNumber: phoneNumber, email: email)
                dismiss()
            }
            .disabled(name.isEmpty))
        }
    }
}
