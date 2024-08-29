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

            DatePicker("Wedding Date", selection: $weddingDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding()
            
            Text("Theme Color") // tab bar and rectangle color
                .font(.title2).fontWeight(.bold)
                .padding()
                ColorPicker("Theme Color", selection: Binding(
                    get: { Color(selectedColor) },
                    set: { newColor in
                        selectedColor = UIColor(newColor)
                    }
                ))
            Spacer()

            Button(action: saveProfile) {
                Text("Save")
                    .padding()
            }
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

            // Dismiss the view
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ProfileView(weddingDate: .constant(Date()), userName: .constant("Derek"), spouseName: .constant("Kaylee"), selectedColor: .constant(.systemIndigo))
}
