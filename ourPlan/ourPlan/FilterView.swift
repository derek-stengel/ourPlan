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

                Section {
                    Text("Enabling precise location in the Settings app will allow a dot on the map displaying where you currently are.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                }
                .listRowBackground(Color(UIColor.secondarySystemBackground))
            }
            .navigationTitle("Filters")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
    
    private func applyFilters() {
        viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: "")
    }
}

#Preview {
    FilterView(viewModel: MapViewModel(), city: .constant("Salt Lake"), state: .constant("UT"), radius: .constant(50.0))
}
