//
//  MapViewModel.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/8/24.
//

import Foundation
import MapKit
import SwiftUI
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7608, longitude: -111.8910), // Salt Lake City
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @Published var locations: [Location] = []  // This will hold the found restaurant locations
    
    private let locationManager = CLLocationManager()
    @AppStorage("locationPermissionShown") private var locationPermissionShown = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        checkLocationAuthorizationStatus()
    }
    
    func searchForRestaurants(city: String, state: String, radius: Double, searchText: String) {
        let request = MKLocalSearch.Request()
        if searchText.isEmpty {
            request.naturalLanguageQuery = "restaurant"
        } else {
            request.naturalLanguageQuery = searchText
        }
        request.region = region
        
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
                self.applyFilters(city: city, state: state, radius: radius, searchText: searchText)
            }
        }
    }
    
    private func checkLocationAuthorizationStatus() {
        if !locationPermissionShown {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
                
            default:
                break
            }
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
            locationPermissionShown = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        region.center = newLocation.coordinate
    }
    
    private func applyFilters(city: String, state: String, radius: Double, searchText: String) {
        let filteredLocations = locations.filter { location in
            // Filter based on radius
            let locationCoordinate = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let centerCoordinate = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
            let distance = locationCoordinate.distance(from: centerCoordinate) * 0.000621371 // meters to miles
            
            let withinRadius = distance <= radius
            
            // Filter based on search text
            let matchesSearchText = searchText.isEmpty || location.name.lowercased().contains(searchText.lowercased())
            
            return withinRadius && matchesSearchText
        }
        
        DispatchQueue.main.async {
            self.locations = filteredLocations
        }
    }
}
