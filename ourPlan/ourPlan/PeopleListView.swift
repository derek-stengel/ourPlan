//
//  PeopleListView.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation
import SwiftUI

struct PeopleListView: View {
    @StateObject private var viewModel = PeopleViewModel()
    @State private var showingAddPerson = false

    var body: some View {
        NavigationView {
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
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                showingAddPerson = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView(viewModel: viewModel)
            }
        }
    }

    private func movePerson(from source: IndexSet, to destination: Int) {
        viewModel.people.move(fromOffsets: source, toOffset: destination)
    }
}
