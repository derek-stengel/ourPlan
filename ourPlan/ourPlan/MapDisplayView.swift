//
//  MapDisplayView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/8/24.
//

import MapKit
import SwiftUI
import UIKit

struct MapDisplayView: View {
    @StateObject private var viewModel = MapViewModel()
    @EnvironmentObject var peopleViewModel: PeopleViewModel
    @State private var selectedLocation: Location? = nil
    @State private var searchText: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var radius: Double = 10.0
    @State private var isFilterPresented: Bool = false
    @Binding var selectedColor: UIColor
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.locations) { location in
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
                viewModel.checkLocationAuthorizationStatus()
            }
            .toolbarBackground(Color(selectedColor).opacity(0.1), for: .tabBar)
            
            if let location = selectedLocation {
                VStack {
                    Spacer()
                    LocationInfoView(location: location, selectedColor: $selectedColor)
                        .environmentObject(peopleViewModel)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding()
                }
            }
            
            VStack {
                HStack(spacing: 10) {
                    Button(action: {
                        isFilterPresented = true
                    }) {
                        Image(systemName: "slider.vertical.3")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.secondary)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(11)
                    }
                   
                    TextField("Search for a restaurant", text: $searchText, onCommit: {
                        applyFilters()
                    })
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .background(Color.white)
                    .foregroundColor(.secondary)
                    .cornerRadius(10)

                    Button(action: {
                        applyFilters()
                    }) {
                        Image(systemName: "arrow.up.right")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(3)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color(selectedColor).opacity(0.7))
                )
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                Spacer()
            }

        }
        .sheet(isPresented: $isFilterPresented) {
            FilterView(viewModel: viewModel, city: $city, state: $state, radius: $radius)
                .onDisappear {
                    applyFilters()
                }
        }
    }
    
    private func applyFilters() {
        viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: searchText)
        print("Applied Filters: City: \(city), State: \(state), Radius: \(radius), SearchText: \(searchText)")
    }
}

struct MapDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        MapDisplayView(selectedColor: .constant(.black))
    }
}

