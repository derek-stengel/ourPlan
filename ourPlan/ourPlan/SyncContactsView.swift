//
//  SyncContactsView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/13/24.
//

import Foundation
import SwiftUI
import Contacts

struct SyncContactsView: View {
    @ObservedObject var viewModel: PeopleViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.contacts, id: \.identifier) { contact in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(contact.givenName) \(contact.familyName)")
                            if !contact.jobTitle.isEmpty {
                                Text(contact.jobTitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        Button(action: {
                            viewModel.addPersonFromContact(contact)
                            // Optionally remove the contact from the list after adding
                            viewModel.contacts.removeAll { $0.identifier == contact.identifier }
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Sync Contacts")
            .navigationBarItems(leading: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                viewModel.fetchContacts()
            }
        }
    }
}



//struct SyncContactsView: View {
//    @ObservedObject var viewModel: PeopleViewModel
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(viewModel.contacts, id: \.identifier) { contact in
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("\(contact.givenName) \(contact.familyName)")
//                            if !contact.jobTitle.isEmpty {
//                                Text(contact.jobTitle)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                        Spacer()
//                        Button(action: {
//                            viewModel.addPersonFromContact(contact)
//                        }) {
//                            Image(systemName: "plus.circle")
//                                .foregroundColor(.blue)
//                        }
//                    }
//                    .padding(.vertical, 4)
//                }
//            }
//            .navigationTitle("Sync Contacts")
//            .navigationBarItems(leading: Button("Cancel") {
//                presentationMode.wrappedValue.dismiss()
//            })
//            .onAppear {
//                viewModel.fetchContacts()
//            }
//        }
//    }
//}
//
