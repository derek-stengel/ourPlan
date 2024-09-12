//
//  SyncContactsView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/13/24.
//

import SwiftUI
import Contacts

struct SyncContactsView: View {
    @ObservedObject var viewModel: PeopleViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedContacts = Set<String>()  // Track selected contacts
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.contacts.sorted(by: {
                    if !$0.familyName.isEmpty && !$1.familyName.isEmpty {
                        return $0.familyName < $1.familyName
                    } else if !$0.familyName.isEmpty {
                        return true
                    } else if !$1.familyName.isEmpty {
                        return false
                    } else {
                        return $0.givenName < $1.givenName
                    }
                }), id: \.identifier) { contact in
                    HStack {
                        Button(action: {
                            if selectedContacts.contains(contact.identifier) {
                                selectedContacts.remove(contact.identifier)
                            } else {
                                selectedContacts.insert(contact.identifier)
                            }
                        }) {
                            Image(systemName: selectedContacts.contains(contact.identifier) ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedContacts.contains(contact.identifier) ? .blue : .gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
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
                            toggleSelection(for: contact)
                        }) {
                            Image(systemName: selectedContacts.contains(contact.identifier) ? "checkmark.circle.fill" : "plus.circle")
                                .foregroundColor(selectedContacts.contains(contact.identifier) ? .green : .blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Sync Contacts")
            .navigationBarItems(
                leading: Button("Done") {
                    importSelectedContacts()
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Import All") {
                    importAllContacts()
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear {
                viewModel.fetchContacts()
            }
        }
    }
    
    private func toggleSelection(for contact: CNContact) {
        if selectedContacts.contains(contact.identifier) {
            selectedContacts.remove(contact.identifier)
        } else {
            selectedContacts.insert(contact.identifier)
        }
    }
    
    private func importSelectedContacts() {
        for contact in viewModel.contacts where selectedContacts.contains(contact.identifier) {
            viewModel.addPersonFromContact(contact)
        }
    }
    
    private func importAllContacts() {
        for contact in viewModel.contacts {
            viewModel.addPersonFromContact(contact)
        }
    }
}

struct SyncContactsView_Previews: PreviewProvider {
    static var previews: some View {
        SyncContactsView(viewModel: PeopleViewModel())
    }
}

//import SwiftUI
//import Contacts
//
//struct SyncContactsView: View {
//    @ObservedObject var viewModel: PeopleViewModel
//    @Environment(\.presentationMode) var presentationMode
//    @State private var selectedContacts = Set<String>()  // Track selected contacts
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(viewModel.contacts.sorted(by: {
//                    if !$0.familyName.isEmpty && !$1.familyName.isEmpty {
//                        return $0.familyName < $1.familyName
//                    } else if !$0.familyName.isEmpty {
//                        return true
//                    } else if !$1.familyName.isEmpty {
//                        return false
//                    } else {
//                        return $0.givenName < $1.givenName
//                    }
//                }), id: \.identifier) { contact in
//                    HStack {
//                        Button(action: {
//                            if selectedContacts.contains(contact.identifier) {
//                                selectedContacts.remove(contact.identifier)
//                            } else {
//                                selectedContacts.insert(contact.identifier)
//                            }
//                        }) {
//                            Image(systemName: selectedContacts.contains(contact.identifier) ? "checkmark.circle.fill" : "circle")
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(selectedContacts.contains(contact.identifier) ? .blue : .gray)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                        
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
//                            toggleSelection(for: contact)
//                        }) {
//                            Image(systemName: selectedContacts.contains(contact.identifier) ? "checkmark.circle.fill" : "plus.circle")
//                                .foregroundColor(selectedContacts.contains(contact.identifier) ? .green : .blue)
//                        }
//                    }
//                    .padding(.vertical, 4)
//                }
//            }
//            .navigationTitle("Sync Contacts")
//            .navigationBarItems(
//                leading: Button("Done") {
//                    importSelectedContacts()
//                    presentationMode.wrappedValue.dismiss()
//                },
//                trailing: Button("Import All") {
//                    importAllContacts()
//                    presentationMode.wrappedValue.dismiss()
//                }
//            )
//            .onAppear {
//                viewModel.fetchContacts()
//            }
//        }
//    }
//    
//    private func toggleSelection(for contact: CNContact) {
//        if selectedContacts.contains(contact.identifier) {
//            selectedContacts.remove(contact.identifier)
//        } else {
//            selectedContacts.insert(contact.identifier)
//        }
//    }
//    
//    private func importSelectedContacts() {
//        for contact in viewModel.contacts where selectedContacts.contains(contact.identifier) {
//            viewModel.addPersonFromContact(contact)
//        }
//    }
//    
//    private func importAllContacts() {
//        for contact in viewModel.contacts {
//            viewModel.addPersonFromContact(contact)
//        }
//    }
//}
//
//struct SyncContactsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SyncContactsView(viewModel: PeopleViewModel())
//    }
//}
