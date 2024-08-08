//
//  MapViewModel.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/8/24.
//

import Foundation
import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7608, longitude: -111.8910), // Default to Salt Lake City
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @Published var locations: [Location] = []  // Holds the found restaurant locations
    @Published var cityQuery: String = ""
    @Published var stateFilter: String? = nil
    
    func searchForRestaurants() {
        // Initialize the request
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurant"
        request.region = region
        
        // Start the search
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Error searching for restaurants: \(error.localizedDescription)")
                return
            }
            
            guard let response = response else {
                print("No response from the search.")
                return
            }
            
            // Print number of items found
            print("Number of restaurants found: \(response.mapItems.count)")
            
            let newLocations = response.mapItems.map { item in
                Location(
                    name: item.name ?? "Unknown",
                    coordinate: item.placemark.coordinate,
                    phoneNumber: item.phoneNumber,
                    address: item.placemark.thoroughfare != nil ? "\(item.placemark.thoroughfare ?? ""), \(item.placemark.locality ?? ""), \(item.placemark.administrativeArea ?? "")" : nil
                )
            }
            
            DispatchQueue.main.async {
                self.locations = newLocations
            }
        }
    }
    
    func updateRegion(for city: String) {
        // Use a geocoding API to find the coordinate of the city
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate else {
                print("No coordinates found.")
                return
            }
            
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // Adjust as needed
                )
            }
        }
    }
}
