//
//  MapView.swift
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
    @State private var isFilterSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter city", text: $searchText, onCommit: {
                    viewModel.updateRegion(for: searchText)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                Button(action: {
                    isFilterSheetPresented = true
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                }
            }
            
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
                    viewModel.searchForRestaurants()
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
            }
        }
        .sheet(isPresented: $isFilterSheetPresented) {
            FilterSheetView(stateFilter: $viewModel.stateFilter)
        }
    }
}
