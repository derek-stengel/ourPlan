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
    @Binding var userName: String
    @Binding var spouseName: String
    
    @State private var userNameError: String? = nil
    @State private var spouseNameError: String? = nil
    @Environment(\.presentationMode) var presentationMode  // Environment variable for dismissing the view
    
    var body: some View {
        VStack {
            Text("Profile Settings")
                .font(.largeTitle)
                .padding()
            
            TextField("User Name", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: userName) { _ in
                    validateUserName()
                }
            
            if let userNameError = userNameError {
                Text(userNameError)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.bottom, 8)
            }
            
            TextField("Spouse Name", text: $spouseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: spouseName) { _ in
                    validateSpouseName()
                }
            
            if let spouseNameError = spouseNameError {
                Text(spouseNameError)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.bottom, 8)
            }
            
            Text("Wedding Date")
                .font(.title2).fontWeight(.bold)
            
            DatePicker("Wedding Date", selection: $weddingDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            Button(action: saveProfile) {
                Text("Save")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
    
    private func validateUserName() {
        if userName.isEmpty {
            userNameError = "Please input a name"
        } else {
            userNameError = nil
        }
    }
    
    private func validateSpouseName() {
        if spouseName.isEmpty {
            spouseNameError = "Please input a name"
        } else {
            spouseNameError = nil
        }
    }
    
    private func saveProfile() {
        validateUserName()
        validateSpouseName()
        
        if userNameError == nil && spouseNameError == nil {
            // Save profile logic
            UserSettings.saveUserName(userName)
            UserSettings.saveSpouseName(spouseName)
            
            // Dismiss the view
            presentationMode.wrappedValue.dismiss()
        }
    }
}



//struct ProfileView: View {
//    @Binding var weddingDate: Date
//    @Binding var userName: String
//    @Binding var spouseName: String
//    
//    var body: some View {
//        VStack {
//            Text("Profile Settings")
//                .font(.largeTitle)
//                .padding()
//            
//            TextField("User Name", text: $userName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            TextField("Spouse Name", text: $spouseName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            DatePicker("Wedding Date", selection: $weddingDate, displayedComponents: .date)
//                .datePickerStyle(GraphicalDatePickerStyle())
//                .padding()
//            
//            Spacer()
//        }
//        .padding()
//    }
//}
//
