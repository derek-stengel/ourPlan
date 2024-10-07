//
//  ProfileView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/9/24.
//
//

import SwiftUI
import MapKit

struct ProfileView: View {
    @Binding var weddingDate: Date
    @Binding var userName: String
    @Binding var spouseName: String
    @Binding var selectedColor: UIColor
    @Binding var weddingCity: String
    
    @State private var userNameError: String? = nil
    @State private var spouseNameError: String? = nil
    @Environment(\.dismiss) var dismiss
    
    // City autocomplete
    @StateObject private var citySearchViewModel = CitySearchViewModel()
    @State private var showDropdown = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(selectedColor))
                    .opacity(0.3)
                    .frame(width: 275)
                    .frame(height: 50)
                Text("Profile Settings")
                    .font(.system(size: 27, design: .serif))
                    .padding(.horizontal)
            }
            
            Spacer().frame(height: 20)
            
            Text("1st Display Name")
                .font(.footnote)
                .padding(.leading, -165)
                .foregroundColor(.gray)
            
            TextField("User Name", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 10)
                .onChange(of: userName) { _ in
                    validateUserName()
                }
            
            if let userNameError = userNameError {
                Text(userNameError)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 10)
                    .padding(.top, 4)
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
            
            Spacer().frame(height: 5)
            
            Text("Wedding City")
                .font(.footnote)
                .padding(.leading, -165)
                .foregroundColor(.gray)
            
            TextField("Wedding City", text: $weddingCity, onEditingChanged: { editing in
                showDropdown = editing
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 10)
            .onChange(of: weddingCity) { newValue in
                citySearchViewModel.updateQuery(query: newValue)
            }
            
            if showDropdown && !citySearchViewModel.completions.isEmpty {
                List(citySearchViewModel.completions, id: \.self) { completion in
                    Text(completion.title)
                        .onTapGesture {
                            weddingCity = completion.title
                            showDropdown = false
                        }
                }
                .frame(height: 200)
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
            UserSettings.saveUserName(userName)
            UserSettings.saveSpouseName(spouseName)
            UserSettings.saveThemeColor(selectedColor)
            UserSettings.saveWeddingDate(weddingDate)
            UserSettings.saveWeddingCity(weddingCity)
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
    ProfileView(weddingDate: .constant(Date()), userName: .constant("Derek"), spouseName: .constant("Kaylee"), selectedColor: .constant(.systemIndigo), weddingCity: .constant("South Jordan, UT"))
}
