//
//  MapDisplayView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/8/24.
//

// MapDisplayView.swift

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
                HStack(spacing: 10) {  // Adjust spacing between elements
                    Button(action: {
                        isFilterPresented = true
                    }) {
                        Image(systemName: "slider.vertical.3")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.secondary)
                            .padding(10)
                            .background(Color.white) // Set background color to gray
                            .cornerRadius(11)
                    }
                   
                    TextField("Search for a restaurant", text: $searchText, onCommit: {
                        viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: searchText)
                    })
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .background(Color.white)
                    .foregroundColor(.secondary) // Ensure text color is white
                    .cornerRadius(10)

                    Button(action: {
                        viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: searchText)
                    }) {
                        Image(systemName: "arrow.up.right")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white) // Set button text color to white
                            .padding(3)
//                            .background(Color.white) // Set background color to gray
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20.0)
//                    .fill(Color.black.opacity(0.7)) // Set the background color of the HStack
                    .fill(Color(selectedColor).opacity(0.7))
                )
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                Spacer()
            }

        }
        .sheet(isPresented: $isFilterPresented) {
            FilterView(viewModel: viewModel, city: $city, state: $state, radius: $radius)
        }
    }
}

struct MapDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        MapDisplayView(selectedColor: .constant(.black))
    }
}

//
//import MapKit
//import SwiftUI
//
//struct MapDisplayView: View {
//    @StateObject private var viewModel = MapViewModel()
//    @State private var selectedLocation: Location? = nil
//    @State private var searchText: String = ""
//    @State private var city: String = ""
//    @State private var state: String = ""
//    @State private var radius: Double = 10.0
//    @State private var isFilterPresented: Bool = false
//    
//    var body: some View {
//        ZStack {
//            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.locations) { location in
//                MapAnnotation(coordinate: location.coordinate) {
//                    Button(action: {
//                        selectedLocation = location
//                    }) {
//                        VStack {
//                            Image(systemName: "mappin.circle.fill")
//                                .resizable()
//                                .frame(width: 30, height: 30)
//                                .foregroundColor(.red)
//                        }
//                    }
//                }
//            }
//            .edgesIgnoringSafeArea(.all)
//            .onAppear {
//                viewModel.checkLocationAuthorizationStatus()
//            }
//            
//            if let location = selectedLocation {
//                VStack {
//                    Spacer()
//                    LocationInfoView(location: location)
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .shadow(radius: 10)
//                        .padding()
//                }
//            }
//            
//            VStack {
//                HStack(spacing: 10) { // Adjust spacing between elements
//                    TextField("Search for a restaurant", text: $searchText, onCommit: {
//                        viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: searchText)
//                    })
//                    .textFieldStyle(PlainTextFieldStyle())
//                    .padding(10)
//                    .background(Color.white)
//                    .foregroundColor(.secondary) // Ensure text color is white
//                    .cornerRadius(11)
//
//                    Button(action: {
//                        viewModel.searchForRestaurants(city: city, state: state, radius: radius, searchText: searchText)
//                    }) {
//                        Text("Search")
//                            .foregroundColor(.secondary) // Set button text color to white
//                            .padding(10)
//                            .background(Color.white) // Set background color to gray
//                            .cornerRadius(11)
//                    }
//
//                    Button(action: {
//                        isFilterPresented = true
//                    }) {
//                        Image(systemName: "slider.horizontal.3")
//                            .foregroundColor(.secondary)
//                            .padding(10)
//                            .background(Color.white) // Set background color to gray
//                            .cornerRadius(11)
//                    }
//                }
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 20.0)
//                    .fill(Color.secondary.opacity(0.9)) // Set the background color of the HStack
//                )
//                .padding(.horizontal)
//                .frame(maxWidth: .infinity)
//                Spacer()
//            }
//
//        }
//        .sheet(isPresented: $isFilterPresented) {
//            FilterView(viewModel: viewModel, city: $city, state: $state, radius: $radius)
//        }
//    }
//}
//
//struct MapDisplayView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapDisplayView()
//    }
//}
