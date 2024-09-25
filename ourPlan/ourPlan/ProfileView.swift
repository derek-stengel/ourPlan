//
//  ProfileView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/9/24.
//
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @Binding var weddingDate: Date
    @Binding var userName: String
    @Binding var spouseName: String
    @Binding var selectedColor: UIColor

    @State private var userNameError: String? = nil
    @State private var spouseNameError: String? = nil
    @Environment(\.dismiss) var dismiss  // Environment variable for dismissing the view

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(selectedColor))
                    .opacity(0.3)
                    .frame(width: 275)
                    .frame(height: 50)
                Text("Profile Settings")
//                    .font(.title)
//                    .fontWeight(.light)
                    .font(.system(size: 27, design: .serif))
                    .padding(.horizontal)
            }
            
            // Add spacing between Profile Settings and the next section
            Spacer().frame(height: 20)
            
            // Align "Receive an Alert" to the leading edge
            Text("1st Display Name")
                .font(.footnote)
                .padding(.leading, -165)
                .foregroundColor(.gray)
            
            // Align the TextField and error message to the leading edge
            TextField("User Name", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 10) // Match the padding with the header
                .onChange(of: userName) { _ in
                    validateUserName()
                }
            
            if let userNameError = userNameError {
                Text(userNameError)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 10) // Align error message with the text field
                    .padding(.top, 4) // Add some space above the error message
    }
            
            Spacer().frame(height: 5)
            
            Text("2nd Display Name")
                .font(.footnote)
                .padding(.leading, -165)
                .foregroundColor(.gray)
            
                TextField("Spouse Name", text: $spouseName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 10)
                    .onChange(of: spouseName) { _ in
                        validateSpouseName()
                    }
                
                if let spouseNameError = spouseNameError {
                    Text(spouseNameError)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.bottom, 8)
                }
            
            Spacer().frame(height: 20)

            DatePicker(
                selection: $weddingDate,
                in: Date()...,
                displayedComponents: .date
            ) {
                Text("Wedding Date")
                    .font(.system(size: 20, design: .serif))
                    .fontWeight(.bold)
            }
            .datePickerStyle(CompactDatePickerStyle())
            .padding(.leading)
            .onChange(of: weddingDate) { newDate in
                UserSettings.saveWeddingDate(newDate)
            }

            Spacer().frame(height: 15)

            HStack {
                Text("Theme Color")
                    .font(.system(size: 20, design: .serif))
                    .fontWeight(.bold)
                ColorPicker("", selection: Binding(
                    get: { Color(selectedColor) },
                    set: { newColor in
                        selectedColor = UIColor(newColor)
                        UserSettings.saveThemeColor(selectedColor)
                    }
                ))
            }
            .padding(.leading)

            Spacer()

            Button(action: saveProfile) {
                Text("Save")
                    .padding()
            }
            .font(.system(size: 20, design: .serif))
            .bold()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .frame(minHeight: 50)
            .cornerRadius(10)
            .alert(isPresented: .constant(userNameError != nil || spouseNameError != nil)) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text(userNameError ?? spouseNameError ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
        .onAppear {
            loadProfileData()
        }
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
            UserSettings.saveThemeColor(selectedColor)
            UserSettings.saveWeddingDate(weddingDate)

            // Dismiss the view
            dismiss()
        }
    }

    private func loadProfileData() {
        userName = UserSettings.getUserName() ?? ""
        spouseName = UserSettings.getSpouseName() ?? ""
        selectedColor = UserSettings.getThemeColor()
        weddingDate = UserSettings.getWeddingDate() ?? Date()
    }
}

#Preview {
    ProfileView(weddingDate: .constant(Date()), userName: .constant("Derek"), spouseName: .constant("Kaylee"), selectedColor: .constant(.systemIndigo))
}

//
//import Foundation
//import SwiftUI
//
//struct ProfileView: View {
//    @Binding var weddingDate: Date
//    @Binding var userName: String
//    @Binding var spouseName: String
//    @Binding var selectedColor: UIColor
//
//    @State private var userNameError: String? = nil
//    @State private var spouseNameError: String? = nil
//    @Environment(\.presentationMode) var presentationMode  // Environment variable for dismissing the view
//
//    var body: some View {
//        VStack(alignment: .center, spacing: 12) {
//            ZStack {
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color(selectedColor))
//                    .opacity(0.3)
//                    .frame(width: 275)
//                    .frame(height: 50)
//                Text("Profile Settings")
////                    .font(.title)
////                    .fontWeight(.light)
//                    .font(.system(size: 27, design: .serif))
//                    .padding(.horizontal)
//            }
//            
//            // Add spacing between Profile Settings and the next section
//            Spacer().frame(height: 20)
//            
//            // Align "Receive an Alert" to the leading edge
//            Text("1st Display Name")
//                .font(.footnote)
//                .padding(.leading, -165)
//                .foregroundColor(.gray)
//            
//            // Align the TextField and error message to the leading edge
//            TextField("User Name", text: $userName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding(.leading, 10) // Match the padding with the header
//                .onChange(of: userName) { _ in
//                    validateUserName()
//                }
//            
//            if let userNameError = userNameError {
//                Text(userNameError)
//                    .font(.caption)
//                    .foregroundColor(.red)
//                    .padding(.leading, 10) // Align error message with the text field
//                    .padding(.top, 4) // Add some space above the error message
//    }
//            
//            Spacer().frame(height: 5)
//            
//            Text("2nd Display Name")
//                .font(.footnote)
//                .padding(.leading, -165)
//                .foregroundColor(.gray)
//            
//                TextField("Spouse Name", text: $spouseName)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.leading, 10)
//                    .onChange(of: spouseName) { _ in
//                        validateSpouseName()
//                    }
//                
//                if let spouseNameError = spouseNameError {
//                    Text(spouseNameError)
//                        .font(.caption)
//                        .foregroundColor(.red)
//                        .padding(.bottom, 8)
//                }
//            
//            Spacer().frame(height: 20)
//
//            DatePicker(
//                selection: $weddingDate,
//                in: Date()...,
//                displayedComponents: .date
//            ) {
//                Text("Wedding Date")
//                    .font(.title3)
//                    .fontWeight(.bold)
//            }
//            .datePickerStyle(CompactDatePickerStyle())
//            .padding(.leading)
//            .onChange(of: weddingDate) { newDate in
//                UserSettings.saveWeddingDate(newDate)
//            }
//
//            Spacer().frame(height: 15)
//
//            HStack {
//                Text("Theme Color")
//                    .font(.title3)
//                    .fontWeight(.bold)
//                ColorPicker("", selection: Binding(
//                    get: { Color(selectedColor) },
//                    set: { newColor in
//                        selectedColor = UIColor(newColor)
//                        UserSettings.saveThemeColor(selectedColor)
//                    }
//                ))
//            }
//            .padding(.leading)
//
//            Spacer()
//
//            Button(action: saveProfile) {
//                Text("Save")
//                    .padding()
//            }
//            .frame(maxWidth: .infinity)
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .frame(minHeight: 50)
//            .cornerRadius(10)
//            .alert(isPresented: .constant(userNameError != nil || spouseNameError != nil)) {
//                Alert(
//                    title: Text("Invalid Input"),
//                    message: Text(userNameError ?? spouseNameError ?? ""),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//        }
//        .padding()
//        .onAppear {
//            loadProfileData()
//        }
//    }
//
//    private func validateUserName() {
//        if userName.isEmpty {
//            userNameError = "Please input a name"
//        } else {
//            userNameError = nil
//        }
//    }
//
//    private func validateSpouseName() {
//        if spouseName.isEmpty {
//            spouseNameError = "Please input a name"
//        } else {
//            spouseNameError = nil
//        }
//    }
//
//    private func saveProfile() {
//        validateUserName()
//        validateSpouseName()
//
//        if userNameError == nil && spouseNameError == nil {
//            // Save profile logic
//            UserSettings.saveUserName(userName)
//            UserSettings.saveSpouseName(spouseName)
//            UserSettings.saveThemeColor(selectedColor)
//            UserSettings.saveWeddingDate(weddingDate)
//
//            // Dismiss the view
//            presentationMode.wrappedValue.dismiss()
//        }
//    }
//
//    private func loadProfileData() {
//        userName = UserSettings.getUserName() ?? ""
//        spouseName = UserSettings.getSpouseName() ?? ""
//        selectedColor = UserSettings.getThemeColor()
//        weddingDate = UserSettings.getWeddingDate() ?? Date()
//    }
//}
//
//#Preview {
//    ProfileView(weddingDate: .constant(Date()), userName: .constant("Derek"), spouseName: .constant("Kaylee"), selectedColor: .constant(.systemIndigo))
//}
