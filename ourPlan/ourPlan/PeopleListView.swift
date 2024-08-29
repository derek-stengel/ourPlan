//
//  PeopleListView.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation
import SwiftUI
import Contacts

struct PeopleListView: View {
    @StateObject private var viewModel = PeopleViewModel()
    @State private var showingAddPerson = false
    @State private var showingSyncContacts = false
    @State private var contactsImported = false // Track if contacts have been imported

    var body: some View {
        NavigationView {
            VStack {
                if !contactsImported {
                    // Show blue button in the middle of the screen
                    Spacer()
                    Button(action: {
                        showingSyncContacts = true
                    }) {
                        Text("Import Contacts")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.title2)
                    }
                    Spacer()
                } else {
                    // Show the list of people if contacts have been imported
                    List {
                        ForEach($viewModel.people) { $person in
                            NavigationLink(destination: EditPersonView(person: $person)) {
                                VStack(alignment: .leading) {
                                    Text(person.name)
                                        .font(.headline)
                                    Text(person.job)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .onDelete(perform: viewModel.deletePerson)
                        .onMove(perform: movePerson)
                    }
                    .navigationTitle("People")
                }
            }
            .navigationBarItems(leading: HStack {
                if contactsImported {
                    EditButton()
                    Button(action: {
                        showingSyncContacts = true
                    }) {
                        Image(systemName: "person.2.circle")
                    }
                }
            }, trailing: Button(action: {
                showingAddPerson = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingSyncContacts) {
                SyncContactsView(viewModel: viewModel)
                    .onDisappear {
                        // Update the contactsImported state once SyncContactsView is dismissed
                        contactsImported = true
                    }
            }
        }
    }

    private func movePerson(from source: IndexSet, to destination: Int) {
        viewModel.people.move(fromOffsets: source, toOffset: destination)
    }
}

struct PeopleListView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleListView()
    }
}
