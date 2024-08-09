//
//  ProfileView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/9/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @Binding var weddingDate: Date

    var body: some View {
        VStack {
            Text("Profile Settings")
                .font(.largeTitle)
                .padding()

            DatePicker("Wedding Date", selection: $weddingDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            Spacer()
        }
        .padding()
    }
}
