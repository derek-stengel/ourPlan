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
    @Binding var selectedColor: UIColor

    var body: some View {
        VStack {
            Image("ourPlanLogoRed")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .rotatingGradientBorderHome(selectedColor: $selectedColor)
                
            
            Spacer().frame(height: 20)
            Text("Enter Your Names")
                .font(.system(size: 40, design: .serif))
                .font(.largeTitle)
                .padding()

            TextField("Your Name", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Spouse's Name", text: $spouseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Spacer().frame(height: 50)

            Button(action: {
                UserSettings.saveUserName(userName)
                UserSettings.saveSpouseName(spouseName)
                isPresented = false
            }) {
                Text("Save")
                    .font(.system(size: 25, design: .serif))
                    .font(.title)
                    .padding()
                    .frame(height: 65)
                    .frame(width: 300)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .preferredColorScheme(.light)
        .padding()
    }
}

struct NameEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NameEntryView(isPresented: .constant(true), selectedColor: .constant(.red))
    }
}
