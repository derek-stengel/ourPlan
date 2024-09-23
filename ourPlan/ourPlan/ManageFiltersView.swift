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

    // State to handle navigation to the custom filter view
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
//                leading: NavigationLink(destination: CreateCustomFilterView(
//                    selectedFilter: $selectedFilter,
//                    showingCustomFilterSheet: .constant(false), selectedColor: $selectedColor // Not needed since it's handled by the navigation
//                )) {
//                    Image(systemName: "plus") // "+" icon for adding a filter
//                },
                trailing: Button("Done") {
                    // Save updated filters to UserDefaults
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



//struct ManageFiltersView: View {
//    @Binding var filters: [String] // The list of custom filters
//    @Environment(\.presentationMode) var presentationMode
//    
//
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(filters, id: \.self) { filter in
//                    Text(filter)
//                }
//                .onDelete(perform: deleteFilter)
//            }
//            .navigationTitle("Manage Filters")
//            .navigationBarItems(
//                leading: NavigationLink("+") {
//                    CreateCustomFilterView(selectedFilter: <#Binding<String>#>, showingCustomFilterSheet: <#Binding<Bool>#>)
//                },
//                trailing: Button("Done") {
//                    // Save updated filters to UserDefaults
//                    Event.defaultFilters = filters
//                    presentationMode.wrappedValue.dismiss()
//                })
//        }
//    }
//
//    private func deleteFilter(at offsets: IndexSet) {
//        filters.remove(atOffsets: offsets)
//        // Remove filter from UserDefaults
//        Event.defaultFilters = filters
//    }
//}

struct ManageFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        ManageFiltersView(filters: .constant(["Custom Filter 1", "Custom Filter 2"]), selectedColor: .constant(.blue))
    }
}

