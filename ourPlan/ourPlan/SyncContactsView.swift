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


// SEARCH BAR CODE
//import SwiftUI
//import Contacts
//
//struct SyncContactsView: View {
//    @State private var allContacts: [CNContact] = [] // All available contacts
//    @State private var displayedContacts: [CNContact] = [] // Contacts to display (filtered)
//    @State private var searchText: String = ""
//    @State private var hasImportedContacts: Bool = false // Tracks if contacts have been imported before
//    
//    var body: some View {
//        VStack {
//            if !hasImportedContacts || displayedContacts.isEmpty {
//                VStack {
//                    Text("No contacts imported yet.")
//                        .padding()
//                    Button(action: {
//                        fetchContacts()
//                    }) {
//                        Text("Import Contacts")
//                            .font(.headline)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//                }
//            } else {
//                VStack {
//                    // Search bar
//                    TextField("Search contacts...", text: $searchText)
//                        .padding(10)
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
//                        .padding([.horizontal, .top])
//                        .onChange(of: searchText) { newValue in
//                            filterContacts()
//                        }
//                    
//                    List(displayedContacts, id: \.identifier) { contact in
//                        HStack {
//                            Text("\(contact.givenName) \(contact.familyName)")
//                        }
//                    }
//                    .listStyle(InsetGroupedListStyle())
//                    
//                    Button(action: {
//                        fetchContacts()
//                    }) {
//                        Text("Import More Contacts")
//                            .font(.headline)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    .padding()
//                }
//            }
//        }
//        .onAppear {
//            if allContacts.isEmpty {
//                fetchContacts()
//            }
//        }
//    }
//    
//    // Fetch contacts from the device
//    private func fetchContacts() {
//        let store = CNContactStore()
//        store.requestAccess(for: .contacts) { granted, error in
//            if granted {
//                let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
//                let request = CNContactFetchRequest(keysToFetch: keysToFetch)
//                
//                do {
//                    var contacts: [CNContact] = []
//                    try store.enumerateContacts(with: request) { contact, stop in
//                        contacts.append(contact)
//                    }
//                    DispatchQueue.main.async {
//                        allContacts = contacts
//                        displayedContacts = allContacts
//                        hasImportedContacts = true
//                    }
//                } catch {
//                    print("Failed to fetch contacts: \(error)")
//                }
//            } else {
//                print("Access to contacts was denied.")
//            }
//        }
//    }
//    
//    // Filter contacts based on search text
//    private func filterContacts() {
//        if searchText.isEmpty {
//            displayedContacts = allContacts
//        } else {
//            displayedContacts = allContacts.filter {
//                $0.givenName.lowercased().contains(searchText.lowercased()) ||
//                $0.familyName.lowercased().contains(searchText.lowercased())
//            }
//        }
//    }
//}

