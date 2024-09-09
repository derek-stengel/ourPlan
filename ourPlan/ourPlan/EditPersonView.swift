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
    @Environment(\.presentationMode) var presentationMode

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
        }
        .navigationTitle("Edit Person")
        .navigationBarItems(trailing: Button("Save") {
            presentationMode.wrappedValue.dismiss()
        })
    }
}


//import Foundation
//import SwiftUI
//import Contacts
//
//struct EditPersonView: View {
//    @Binding var person: Person
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        Form {
//            Section(header: Text("Name")) {
//                TextField("Name", text: $person.name)
//            }
//            Section(header: Text("Job")) {
//                TextField("Job", text: $person.job)
//            }
//            Section(header: Text("Phone Number")) {
//                TextField("Phone Number", text: $person.phoneNumber)
//            }
//            Section(header: Text("Email")) {
//                TextField("Email Address", text: $person.email)
//            }
//        }
//        .navigationTitle("Edit Person")
//        .navigationBarItems(trailing: Button("Save") {
//            presentationMode.wrappedValue.dismiss()
//        })
//    }
//}
