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
//    @ObservedObject var viewModel: PeopleViewModel

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
//            Spacer()
//            
//            Button(action: {
//                viewModel.deletePerson(by: person.id)
//            }) {
//                Text("Delete Contact")
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.red)
//                    .cornerRadius(10)
//            }
//            .padding()
        }
        .navigationTitle("Edit Person")
        .navigationBarItems(trailing: Button("Save") {
            presentationMode.wrappedValue.dismiss()
        })
    }
}

//struct EditPerson_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPersonView(person: .constant(Person(name: "derek", job: "iOS Dev", phoneNumber: "801-123-4567", email: "random@gmail.com")), viewModel: PeopleViewModel())
//    }
//}


//import Foundation
//import SwiftUI
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
