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
        // Clear out old locations
        locations.removeAll()
        
        // Prepare the MKLocalSearch request
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText.isEmpty ? "restaurant" : searchText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error searching for restaurants: \(error.localizedDescription)")
                return
            }
            
            guard let response = response else {
                print("No response from the search.")
                return
            }
            
            // Log the number of results found
            print("Found \(response.mapItems.count) items in the initial search.")
            
            // Use CLGeocoder to get coordinates for the input city
            let geocoder = CLGeocoder()
            let address = "\(city), \(state)"
            
            geocoder.geocodeAddressString(address) { placemarks, error in
                if let error = error {
                    print("Error geocoding city: \(error.localizedDescription)")
                    return
                }
                
                guard let placemark = placemarks?.first, let cityLocation = placemark.location else {
                    print("No location found for \(address).")
                    return
                }
                
                // Prepare to store new locations
                let newLocations = response.mapItems.compactMap { item in
                    let streetNumber = item.placemark.subThoroughfare ?? ""
                    let street = item.placemark.thoroughfare ?? ""
                    let locationCity = item.placemark.locality?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    let locationState = item.placemark.administrativeArea?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    let postalCode = item.placemark.postalCode ?? ""
                    
                    let fullStreet = [streetNumber, street].filter { !$0.isEmpty }.joined(separator: " ")
                    let fullAddress = [fullStreet, locationCity, locationState.uppercased(), postalCode]
                        .filter { !$0.isEmpty }
                        .joined(separator: ", ")
                    
                    let locationCoordinate = item.placemark.coordinate
                    
                    // Log the found location details
                    print("Location found: \(item.name ?? "Unknown"), City: \(locationCity), State: \(locationState)")
                    
                    // Calculate distance from the city location
                    let distance = self.calculateDistance(from: cityLocation.coordinate, to: locationCoordinate)
                    
                    // Include if it's within the radius
                    if distance <= radius {
                        return Location(
                            name: item.name ?? "Unknown",
                            coordinate: locationCoordinate,
                            phoneNumber: item.phoneNumber,
                            address: fullAddress.isEmpty ? nil : fullAddress
                        )
                    }
                    return nil // Exclude locations outside of radius
                }
                
                // Update locations on the main thread
                DispatchQueue.main.async {
                    self.locations = newLocations
                    
                    // Log the final number of filtered locations
                    print("Found \(newLocations.count) locations within \(radius) miles of \(city), \(state).")
                }
            }
        }
    }

    // Helper function to calculate distance in miles between two coordinates
    private func calculateDistance(from userLocation: CLLocationCoordinate2D, to location: CLLocationCoordinate2D) -> Double {
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let targetLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        // Convert meters to miles
        return userCLLocation.distance(from: targetLocation) / 1609.34
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
