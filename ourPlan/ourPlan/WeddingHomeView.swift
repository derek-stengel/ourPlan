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
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                                .padding(.trailing)
                                .padding(.top, 16)
                        }
                        .sheet(isPresented: $isProfileViewPresented) {
                            ProfileView(weddingDate: $weddingDate, userName: $userName, spouseName: $spouseName)
                        }
                    }
                    
                    // Content with text and widget
                    VStack {
                        Text("\(userName) & \(spouseName)")
                            .font(.system(size: 40, design: .serif))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        
                        FloatingWidget(weddingDate: $weddingDate)
                            .frame(width: 300, height: 150)
                            .shadow(radius: 10)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
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
                .font(.system(size: 30, weight: .thin, design: .serif))
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
//    @State private var isNameEntryViewPresented = false
//    @State private var weddingDate = Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 31))!
//    @State private var userName: String = ""
//    @State private var spouseName: String = ""
//    
//    init() {
//        // Check if names are already saved
//        let savedUserName = UserSettings.getUserName()
//        let savedSpouseName = UserSettings.getSpouseName()
//        _userName = State(initialValue: savedUserName ?? "")
//        _spouseName = State(initialValue: savedSpouseName ?? "")
//        _isNameEntryViewPresented = State(initialValue: savedUserName == nil || savedSpouseName == nil)
//    }
//    
//    var body: some View {
//        ZStack {
//            if isNameEntryViewPresented {
//                NameEntryView(isPresented: $isNameEntryViewPresented)
//            } else {
//                VStack {
//                    // Top bar with profile icon
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            isProfileViewPresented.toggle()
//                        }) {
//                            Image(systemName: "person.fill")
//                                .resizable()
//                                .frame(width: 20, height: 20)
//                                .foregroundColor(.black)
//                                .padding(.trailing)
//                                .padding(.top, 16)
//                        }
//                        .sheet(isPresented: $isProfileViewPresented) {
//                            ProfileView(weddingDate: $weddingDate)
//                        }
//                    }
//                    
//                    // Content with text and widget
//                    VStack {
//                        Text("\(userName) & \(spouseName)")
//                            .font(.system(size: 40, design: .serif))
//                            .foregroundColor(.black)
////                            .padding(.top, 1) // Space between text and widget
//                            .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
//                            .padding()
//                        
//                        FloatingWidget(weddingDate: $weddingDate)
//                            .frame(width: 300, height: 150)
//                            .shadow(radius: 10)
//                            .padding(.leading) // Add space from the left
//                            .frame(maxWidth: .infinity, alignment: .leading) // Align widget to the left
//                    }
////                    .padding(.top, 10) // Adjust this value to control the space from the top
//                    
//                    Spacer()
//                }
//            }
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
//                .fill(Color.indigo.opacity(0.8))
//                .frame(width: 300, height: 150)
//            
//            Text(buildAttributedText(for: daysRemaining))
//                .font(.system(size: 30, weight: .thin, design: .serif))
//                .foregroundColor(.white)
//                .padding()
//        }
//    }
//    
//    func buildAttributedText(for daysRemaining: Int) -> AttributedString {
//        var attributedString = AttributedString("\(daysRemaining) days until the Best Day Ever!")
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
