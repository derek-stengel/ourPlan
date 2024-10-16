//
//  ManageFiltersView.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/17/24.
//

import SwiftUI

struct ManageFiltersView: View {
    @Binding var filters: [String] // The list of custom filters
    @Environment(\.dismiss) var dismiss
    @Binding var selectedColor: UIColor

    @State private var selectedFilter: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filters, id: \.self) { filter in
                    Text(filter)
                }
                .onDelete(perform: deleteFilter)
            }
            .navigationTitle("Manage Filters")
            .navigationBarItems(
                trailing: Button("Done") {
                    Event.defaultFilters = filters
                    dismiss()
                }
            )
        }
    }

    private func deleteFilter(at offsets: IndexSet) {
        filters.remove(atOffsets: offsets)
        // Remove filter from UserDefaults
        Event.defaultFilters = filters
    }
}

