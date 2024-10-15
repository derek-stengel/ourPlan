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
        center: CLLocationCoordinate2D(latitude: 39.8283, longitude: -98.5795), // Default to United States
        span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50) // Zoomed out
    )
    
    @Published var locations: [Location] = []  // This will hold the found restaurant locations
    
    private let locationManager = CLLocationManager()
    @AppStorage("locationPermissionShown") private var locationPermissionShown = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorizationStatus()
    }
    
    func applyStateFilter(_ state: String) {
            self.locations = self.locations.filter { $0.address?.contains(state) == true }
    }
    
    func searchForRestaurants(city: String, state: String, radius: Double, searchText: String) {
        locations.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText.isEmpty ? "restaurant" : searchText
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
                let streetNumber = item.placemark.subThoroughfare ?? ""
                let street = item.placemark.thoroughfare ?? ""
                let city = item.placemark.locality ?? ""
                let state = item.placemark.administrativeArea ?? ""
                let postalCode = item.placemark.postalCode ?? ""
                
                let fullStreet = [streetNumber, street].filter { !$0.isEmpty }.joined(separator: " ")
                
                let fullAddress = [fullStreet, city, state, postalCode]
                    .filter { !$0.isEmpty }
                    .joined(separator: ", ")
                
                return Location(
                    name: item.name ?? "Unknown",
                    coordinate: item.placemark.coordinate,
                    phoneNumber: item.phoneNumber,
                    address: fullAddress.isEmpty ? nil : fullAddress
                )
            }
            
            DispatchQueue.main.async {
                self.locations = newLocations
            }
        }
    }
    
    func checkLocationAuthorizationStatus() {
        if !locationPermissionShown {
            switch locationManager.authorizationStatus {
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
}
