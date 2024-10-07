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
                        .foregroundColor(Color(selectedColor)) // change the foreground color back to this before publishing
//                        .foregroundColor(Color(.black)) // replace this
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
        }
        .padding()
        .frame(maxWidth: .infinity)
//        .background(Color(.systemCyan)) // delete this before pushing version 1.1
        .sheet(item: $selectedLocation) { location in
            AddPersonView(
                name: location.name,
                phoneNumber: location.phoneNumber ?? "",
                address: location.address ?? ""
            )
            .environmentObject(peopleViewModel)
        }
    }
}
