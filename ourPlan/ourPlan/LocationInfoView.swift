//
//  LocationInfoView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/8/24.
//

import Foundation
import MapKit
import SwiftUI

struct LocationInfoView: View {
    let location: Location
    @State private var selectedLocation: Location? = nil
    @Binding var selectedColor: UIColor
    @EnvironmentObject var peopleViewModel: PeopleViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(location.name)
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button(action: {
                    selectedLocation = location
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(Color(selectedColor))
                        .padding(.bottom, 0)
                }
            }
            if let phoneNumber = location.phoneNumber {
                Text("Phone: \(phoneNumber)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if let address = location.address {
                Text("Address: \(address)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack {
                Button(action: {
                    openGoogleMaps(for: location)
                }) {
                    Text("Open in Google Maps")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(height: 40)
                        .background(Color(selectedColor))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 5)
                
                Spacer()
                
                if let phoneNumber = location.phoneNumber {
                    Button(action: {
                        openPhoneApp(with: phoneNumber)
                    }) {
                        Image(systemName: "phone")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Color(selectedColor))
                    }
                    .padding(.top, 5)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .sheet(item: $selectedLocation) { location in
            AddPersonView(
                name: location.name,
                phoneNumber: location.phoneNumber ?? "",
                address: location.address ?? ""
            )
            .environmentObject(peopleViewModel)
        }
    }
    
    private func openGoogleMaps(for location: Location) {
        guard let address = location.address else { return }
        let urlString = "https://www.google.com/maps/search/?api=1&query=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func openPhoneApp(with phoneNumber: String) {
        let urlString = "tel:\(phoneNumber)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    LocationInfoView(location: Location(name: "Random Bakery", coordinate: CLLocationCoordinate2D(latitude: 40.7608, longitude: -111.8910), phoneNumber: "801-874-6573", address: "841 Sesame St, Salt Lake City, UT"), selectedColor: .constant(.systemCyan))
}
