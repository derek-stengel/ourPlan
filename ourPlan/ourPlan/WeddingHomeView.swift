//
//  WeddingHomeView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/9/24.
//

import SwiftUI

struct WeddingHomeView: View {
    @State private var isProfileViewPresented = false
    @State private var isNameEntryViewPresented = false
    @State private var weddingDate = Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 31))!
    @State private var userName: String = ""
    @State private var spouseName: String = ""
    
    init() {
        // Check if names are already saved
        let savedUserName = UserSettings.getUserName()
        let savedSpouseName = UserSettings.getSpouseName()
        _userName = State(initialValue: savedUserName ?? "")
        _spouseName = State(initialValue: savedSpouseName ?? "")
        _isNameEntryViewPresented = State(initialValue: savedUserName == nil || savedSpouseName == nil)
    }
    
    var body: some View {
        ZStack {
            if isNameEntryViewPresented {
                NameEntryView(isPresented: $isNameEntryViewPresented)
            } else {
                VStack {
                    // Top bar with profile icon
                    HStack {
                        Spacer()
                        Button(action: {
                            isProfileViewPresented.toggle()
                        }) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .padding(.trailing)
                        }
                        .sheet(isPresented: $isProfileViewPresented) {
                            ProfileView(weddingDate: $weddingDate)
                        }
                    }
//                    .padding()
                    
                    // Content with text and widget
                    VStack {
                        Text("\(userName) & \(spouseName)")
                            .font(.system(size: 40, design: .serif))
                            .foregroundColor(.black)
                            .padding(.top, 16) // Space between text and widget
                            .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                            .padding()
                        
                        FloatingWidget(weddingDate: $weddingDate)
                            .frame(width: 300, height: 150)
                            .shadow(radius: 10)
                            .padding(.leading) // Add space from the left
                            .frame(maxWidth: .infinity, alignment: .leading) // Align widget to the left
                    }
                    .padding(.top, 10) // Adjust this value to control the space from the top
                    
                    Spacer()
                }
            }
        }
    }
}

struct FloatingWidget: View {
    @Binding var weddingDate: Date
    
    var body: some View {
        let daysRemaining = calculateDaysRemaining(until: weddingDate)
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.indigo.opacity(0.8))
                .frame(width: 300, height: 150)
            
            Text(buildAttributedText(for: daysRemaining))
                .font(.system(size: 24, design: .serif))
                .foregroundColor(.white)
                .padding()
        }
    }
    
    func buildAttributedText(for daysRemaining: Int) -> AttributedString {
        var attributedString = AttributedString("\(daysRemaining) days until the Best Day Ever!")
        
        if let range = attributedString.range(of: "\(daysRemaining)") {
            attributedString[range].font = .system(size: 36, weight: .bold, design: .serif)
        }
        
        return attributedString
    }
    
    func calculateDaysRemaining(until date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: date)
        return components.day ?? 0
    }
}






//struct WeddingHomeView: View {
//    @State private var isProfileViewPresented = false
//    @State private var weddingDate = Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 31))!
//
//    var body: some View {
//        ZStack {
//            VStack {
//                // Top bar with profile icon
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        isProfileViewPresented.toggle()
//                    }) {
//                        Image(systemName: "person.fill")
//                            .resizable()
//                            .frame(width: 25, height: 25)
//                            .foregroundColor(.black)
//                    }
//                    .sheet(isPresented: $isProfileViewPresented) {
//                        ProfileView(weddingDate: $weddingDate)
//                    }
//                }
//                .padding()
//                
//                Spacer()
//            }
//
//            // Widget in the top left corner with some space from the top
//            VStack {
//                HStack {
//                    FloatingWidget(weddingDate: $weddingDate)
//                        .frame(width: 300, height: 150)
//                        .shadow(radius: 10)
//                        .padding(.leading) // Add space from the left
//                    Spacer()
//                }
//                Spacer()
//            }
//            .padding(.top, 90) // Adjust this value to control the space from the top
//        }
//    }
//}
//
//struct FloatingWidget: View {
//    @Binding var weddingDate: Date
//
//    var body: some View {
//        let daysRemaining = calculateDaysRemaining(until: weddingDate)
//
//        ZStack {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color.cyan.opacity(0.8))
//                .frame(width: 300, height: 150)
//
//            Text(buildAttributedText(for: daysRemaining))
//                .font(.system(size: 36, design: .serif))
//                .foregroundColor(.white)
//        }
//    }
//
//    func buildAttributedText(for daysRemaining: Int) -> AttributedString {
//        var attributedString = AttributedString("\(daysRemaining) Days until the Best Day Ever!")
//        
//        if let range = attributedString.range(of: "\(daysRemaining)") {
//            attributedString[range].font = .system(size: 36, weight: .bold, design: .serif)
//        }
//        
//        return attributedString
//    }
//
//    func calculateDaysRemaining(until date: Date) -> Int {
//        let calendar = Calendar.current
//        let now = Date()
//        let components = calendar.dateComponents([.day], from: now, to: date)
//        return components.day ?? 0
//    }
//}
