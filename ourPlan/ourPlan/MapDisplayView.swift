//
//  MapDisplayView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/8/24.
//

import MapKit
import SwiftUI

struct MapDisplayView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedLocation: Location? = nil
    @State private var searchText: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var radius: Double = 10.0
    @State private var isFilterPresented: Bool = false
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Button(action: {
                        selectedLocation = location
                    }) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: searchText)
            }
            
            if let location = selectedLocation {
                VStack {
                    Spacer()
                    LocationInfoView(location: location)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding()
                }
            }
            
            VStack {
                HStack {
                    TextField("Search for a restaurant", text: $searchText, onCommit: {
                        viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: searchText)
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    Button(action: {
                        viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: searchText)
                    }) {
                        Text("Search")
                            .padding()
                    }
                    
                    Button(action: {
                        isFilterPresented = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .sheet(isPresented: $isFilterPresented) {
            FilterView(viewModel: viewModel, city: $city, state: $state, radius: $radius)
        }
    }
}
