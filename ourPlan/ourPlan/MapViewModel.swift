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
        center: CLLocationCoordinate2D(latitude: 40.7608, longitude: -111.8910), // Default to Salt Lake City
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
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
