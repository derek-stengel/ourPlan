//
//  NameEntryView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/9/24.
//

import Foundation
import SwiftUI

struct NameEntryView: View {
    @State private var userName: String = ""
    @State private var spouseName: String = ""
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Enter Your Names")
                .font(.largeTitle)
                .padding()

            TextField("Your Name", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Spouse's Name", text: $spouseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                UserSettings.saveUserName(userName)
                UserSettings.saveSpouseName(spouseName)
                isPresented = false
            }) {
                Text("Save")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}
