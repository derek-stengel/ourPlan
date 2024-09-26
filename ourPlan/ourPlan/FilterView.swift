//
//  FilterView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/8/24.
//

import SwiftUI
import MapKit

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MapViewModel
    @Binding var city: String
    @Binding var state: String
    @Binding var radius: Double
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("City and State")) {
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                }
                
                Section(header: Text("Radius (miles)")) {
                    Slider(value: $radius, in: 1...50, step: 1) {
                        Text("Radius")
                    }
                    Text("\(Int(radius)) miles")
                }
                
                Button("Apply") {
                    applyFilters()
                    viewModel.applyStateFilter(state)
                    viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: "")
                    dismiss()
                }
            }
            .navigationTitle("Filters")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
    
    private func applyFilters() {
        viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: "") // Search with updated filters
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        // Create State variables for the preview
        @State var city = "San Francisco"
        @State var state = "CA"
        @State var radius = 10.0
        
        // Pass these as bindings to the FilterView
        FilterView(viewModel: MapViewModel(), city: $city, state: $state, radius: $radius)
            .preferredColorScheme(.light) // Optional: Set preferred color scheme for preview
//            .previewLayout(.sizeThatFits)  // Optional: Use size that fits for the preview
            .padding()
    }
}

