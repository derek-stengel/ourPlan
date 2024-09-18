//
//  CustomFilterView.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/17/24.
//

import SwiftUI

struct CreateCustomFilterView: View {
    @Binding var selectedFilter: String
    @Binding var showingCustomFilterSheet: Bool
    @State private var newFilter: String = ""
    @State private var filters = Event.defaultFilters
    @Binding var selectedColor: UIColor

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Enter Custom Filter")) {
                        TextField("Custom Filter", text: $newFilter)
                    }
                }
                Button(action: {
                    if !newFilter.isEmpty {
                        // Append the new filter to the list and set it as the selected filter
                        if !filters.contains(newFilter) {
                            filters.append(newFilter)
                            Event.defaultFilters = filters // Update the global list with new filter
                            selectedFilter = newFilter
                        }
                    }
                    showingCustomFilterSheet = false
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(selectedColor))
                        .foregroundColor(Color.secondary)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Custom Filter")
            .navigationBarItems(leading: Button("Cancel") {
                showingCustomFilterSheet = false
            })
        }
    }
}

struct CustomFilterView_Previews: PreviewProvider {
    @State static var selectedFilter: String = "None"
    @State static var showingCustomFilterSheet: Bool = true

    static var previews: some View {
        CreateCustomFilterView(selectedFilter: $selectedFilter, showingCustomFilterSheet: $showingCustomFilterSheet, selectedColor: .constant(.systemCyan))
    }
}


