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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(location.name)
                .font(.headline)
            if let phoneNumber = location.phoneNumber {
                Text("Phone: \(phoneNumber)")
            }
            if let address = location.address {
                Text("Address: \(address)")
            }
        }
        .padding()
    }
}


