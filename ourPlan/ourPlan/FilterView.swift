//
//  FilterView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/8/24.
//

import SwiftUI
import MapKit

struct FilterView: View {
    @Environment(\.presentationMode) var presentationMode
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
                    viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: "")
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Filters")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func applyFilters() {
        viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: "") // Search with updated filters
    }
}
