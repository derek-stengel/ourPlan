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
    @EnvironmentObject var viewModel: PeopleViewModel

    @State var name: String = ""
    @State var job: String = ""
    @State var phoneNumber: String = ""
    @State var email: String = ""
    @State var address: String = ""

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
                Section(header: Text("Address")) {
                    TextField("Address", text: $address)
                }
            }
            .navigationTitle("Add Person")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Save") {
                viewModel.addPerson(name: name, job: job, phoneNumber: phoneNumber, email: email, address: address)
                dismiss()
            }
            .disabled(name.isEmpty))
        }
    }
}

#Preview {
    AddPersonView()
        .environmentObject(PeopleViewModel())
}

