//
//  EditPersonView.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation
import SwiftUI

struct EditPersonView: View {
    @Binding var person: Person
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $person.name)
            }
            Section(header: Text("Job")) {
                TextField("Job", text: $person.job)
            }
            Section(header: Text("Phone Number")) {
                TextField("Phone Number", text: $person.phoneNumber)
            }
            Section(header: Text("Email")) {
                TextField("Email Address", text: $person.email)
            }
            Section(header: Text("Address")) {
                TextField("Address", text: $person.address)
            }
        }
        .navigationTitle("Edit Person")
        .navigationBarItems(trailing: Button("Save") {
            dismiss()
        })
    }
}

#Preview {
    EditPersonView(person: .constant(Person(name: "Derek", job: "IOS Coder", phoneNumber: "801-874-6573", email: "derek.stengel@gmail.com", address: "9547 S High Meadow Dr")))
}
