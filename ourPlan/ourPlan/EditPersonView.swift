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

    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $person.name)
            }
            Section(header: Text("Job")) {
                TextField("Job", text: $person.job)
            }
        }
        .navigationTitle("Edit Person")
    }
}
