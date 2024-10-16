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
                    dismiss()
                }

                Section {
                    HStack {
                        Spacer()
                        Text("Allowing precise location in Settings -> Apps -> OurPlans allows a dot to appear on the map displaying your current location.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        Spacer()
                    }
                }
                .listRowBackground(Color(UIColor.secondarySystemBackground))
            }
            .navigationTitle("Filters")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            },
                trailing: Button("Done") {
                applyFilters()
                dismiss()
            })
        }
    }
    
    private func applyFilters() {
        viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: "")
        print("Filter Applied: City: \(city), State: \(state), Radius: \(radius)")
    }
}

#Preview {
    FilterView(viewModel: MapViewModel(), city: .constant("Salt Lake"), state: .constant("UT"), radius: .constant(50.0))
}

