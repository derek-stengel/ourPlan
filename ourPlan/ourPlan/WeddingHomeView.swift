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
    @Binding private var selectedColor: UIColor
    
    @EnvironmentObject private var eventViewModel: EventViewModel

    init(selectedColor: Binding<UIColor>) {
        let savedUserName = UserSettings.getUserName()
        let savedSpouseName = UserSettings.getSpouseName()
        _userName = State(initialValue: savedUserName ?? "")
        _spouseName = State(initialValue: savedSpouseName ?? "")
        _isNameEntryViewPresented = State(initialValue: savedUserName == nil || savedSpouseName == nil)
        _selectedColor = selectedColor
    }

    var body: some View {
        ZStack {
            if isNameEntryViewPresented {
                NameEntryView(isPresented: $isNameEntryViewPresented)
            } else {
                VStack(spacing: 0) {
                    // Top bar with profile icon
                    HStack {
                        Spacer()
                        Button(action: {
                            isProfileViewPresented.toggle()
                        }) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(selectedColor))
                                .padding(.trailing)
                                .padding(.top, 16)
                        }
                        .sheet(isPresented: $isProfileViewPresented) {
                            ProfileView(weddingDate: $weddingDate, userName: $userName, spouseName: $spouseName, selectedColor: $selectedColor)
                        }
                    }

                    // Content with names + widget
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(userName) & \(spouseName)")
                            .font(.system(size: 40, design: .serif))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding()

                        FloatingWidget(weddingDate: $weddingDate, selectedColor: $selectedColor)
                            .frame(width: 300, height: 160)
                            .shadow(radius: 10)
//                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    
                    // Display upcoming events
                    VStack(alignment: .center, spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(selectedColor))
                                .opacity(0.3)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                            Text("Upcoming Events")
                                .font(.title)
                                .fontWeight(.light)
                                .padding(.horizontal)
                        }
                        if eventViewModel.nextThreeEvents.isEmpty {
                            Text("No upcoming events")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        } else {
                            ForEach(eventViewModel.nextThreeEvents) { event in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.ultraThinMaterial)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                    
                                    // Combine multiple Text views for different parts with their own colors
                                    HStack(spacing: 0) {
                                        Text(event.name.trimmingCharacters(in: .whitespaces))
                                            .font(.headline)
                                            .foregroundColor(Color(selectedColor)) // Name in selected color
                                        
                                        Text(" on ")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                        Text("\(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
                                            .font(.headline)
                                            .foregroundColor(.black) // Date and Time in black color
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .frame(alignment: .center)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                Spacer()
            }
        }
        .background(Color.white)
    }
}

// text fields being the same color and format

//ForEach(eventViewModel.nextThreeEvents) { event in
//    ZStack {
//        RoundedRectangle(cornerRadius: 10)
//            .fill(.ultraThinMaterial)
//            .frame(maxWidth: .infinity)
//            .frame(height: 50)
//        
//        Text("\(event.name.trimmingCharacters(in: .whitespaces)) on \(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
//            .font(.headline)
//            .foregroundColor(Color(selectedColor))
//            .padding(.horizontal)
//            .padding(.vertical, 8)
//            .frame(alignment: .center)
//    }
//        .padding(.horizontal)
//}
//}
//}
//.padding(.top)
//}
//.frame(maxHeight: .infinity, alignment: .top)
//Spacer()
//}
//}
//.background(Color.white)
//}
//}

struct FloatingWidget: View {
    @Binding var weddingDate: Date
    @Binding var selectedColor: UIColor

    var body: some View {
        let daysRemaining = calculateDaysRemaining(until: weddingDate)

        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(selectedColor))
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

struct WeddingHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WeddingHomeView(selectedColor: .constant(.red))
            .environmentObject(EventViewModel())
    }
}

//import SwiftUI
//
//struct WeddingHomeView: View {
//    @State private var isProfileViewPresented = false
//    @State private var isNameEntryViewPresented = false
//    @State private var weddingDate = Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 31))!
//    @State private var userName: String = ""
//    @State private var spouseName: String = ""
//    @Binding private var selectedColor: UIColor
//    
//    @ObservedObject private var eventViewModel = EventViewModel() // Observe the EventViewModel
//
//    init(selectedColor: Binding<UIColor>) {
//        let savedUserName = UserSettings.getUserName()
//        let savedSpouseName = UserSettings.getSpouseName()
//        _userName = State(initialValue: savedUserName ?? "")
//        _spouseName = State(initialValue: savedSpouseName ?? "")
//        _isNameEntryViewPresented = State(initialValue: savedUserName == nil || savedSpouseName == nil)
//        _selectedColor = selectedColor
//    }
//
//    var body: some View {
//        ZStack {
//            if isNameEntryViewPresented {
//                NameEntryView(isPresented: $isNameEntryViewPresented)
//            } else {
//                VStack(spacing: 0) {
//                    // Top bar with profile icon
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            isProfileViewPresented.toggle()
//                        }) {
//                            Image(systemName: "person.circle.fill")
//                                .resizable()
//                                .frame(width: 30, height: 30)
//                                .foregroundColor(Color(selectedColor))
//                                .padding(.trailing)
//                                .padding(.top, 16)
//                        }
//                        .sheet(isPresented: $isProfileViewPresented) {
//                            ProfileView(weddingDate: $weddingDate, userName: $userName, spouseName: $spouseName, selectedColor: $selectedColor)
//                        }
//                    }
//
//                    // Content with names + widget
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text("\(userName) & \(spouseName)")
//                            .font(.system(size: 40, design: .serif))
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity, alignment: .leading)
////                            .padding()
//
//                        FloatingWidget(weddingDate: $weddingDate, selectedColor: $selectedColor)
//                            .frame(width: 300, height: 160)
//                            .shadow(radius: 10)
////                            .padding(.leading)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    .padding()
//                    
//                    // Display upcoming events
//                    VStack(alignment: .leading) {
//                        Text("Upcoming Events")
//                            .font(.headline)
//                            .padding(.horizontal)
//                        
//                        if eventViewModel.nextThreeEvents.isEmpty {
//                            Text("No upcoming events")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                                .padding(.horizontal)
//                        } else {
//                            ForEach(eventViewModel.nextThreeEvents) { event in
//                                Text("\(event.name) on \(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
//                                    .font(.subheadline)
//                                    .padding(.horizontal)
//                            }
//                        }
//                    }
//                    .padding(.top)
//                }
//                .frame(maxHeight: .infinity, alignment: .top)
//                .refreshable {
//                    RefreshAction.self
//                }
//                Spacer()
//            }
//        }
//        .background(Color.white)
//    }
//    
//}
//
//
//
//struct FloatingWidget: View {
//    @Binding var weddingDate: Date
//    @Binding var selectedColor: UIColor
//
//    var body: some View {
//        let daysRemaining = calculateDaysRemaining(until: weddingDate)
//
//        ZStack {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color(selectedColor))
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
//
//struct WeddingHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeddingHomeView(selectedColor: .constant(.red))
//    }
//}


//
//import SwiftUI
//
//struct WeddingHomeView: View {
//    @State private var isProfileViewPresented = false
//    @State private var isNameEntryViewPresented = false
//    @State private var weddingDate = Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 31))!
//    @State private var userName: String = ""
//    @State private var spouseName: String = ""
//    @Binding private var selectedColor: UIColor
//    
//    @ObservedObject private var eventViewModel = EventViewModel() // Observe the EventViewModel
//
//    init(selectedColor: Binding<UIColor>) {
//        let savedUserName = UserSettings.getUserName()
//        let savedSpouseName = UserSettings.getSpouseName()
//        _userName = State(initialValue: savedUserName ?? "")
//        _spouseName = State(initialValue: savedSpouseName ?? "")
//        _isNameEntryViewPresented = State(initialValue: savedUserName == nil || savedSpouseName == nil)
//        _selectedColor = selectedColor
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
//                            Image(systemName: "person.circle.fill")
//                                .resizable()
//                                .frame(width: 30, height: 30)
//                                .foregroundColor(Color(selectedColor))
//                                .padding(.trailing)
//                                .padding(.top, 16)
//                        }
//                        .sheet(isPresented: $isProfileViewPresented) {
//                            ProfileView(weddingDate: $weddingDate, userName: $userName, spouseName: $spouseName, selectedColor: $selectedColor)
//                        }
//                    }
//
//                    // Content with names + widget
//                    VStack {
//                        Text("\(userName) & \(spouseName)")
//                            .font(.system(size: 40, design: .serif))
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity, alignment: .leading)
////                            .padding()
//
//                        FloatingWidget(weddingDate: $weddingDate, selectedColor: $selectedColor)
//                            .frame(width: 300, height: 140)
//                            .shadow(radius: 10)
////                            .padding(.leading)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    .padding()
//
//                    // Display upcoming events
//                    VStack(alignment: .leading) {
//                        Text("Upcoming Events")
//                            .font(.headline)
//                            .padding(.horizontal)
//
//                        List {
//                            ForEach(eventViewModel.nextThreeEvents) { event in
//                                VStack(alignment: .leading) {
//                                    Text(event.name)
//                                        .font(.headline)
//                                    Text("On \(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
//                                        .font(.subheadline)
//                                }
//                            }
//                            .listRowBackground(Color.clear) // Set the background color to clear
//                        }
//                        .background(Color.clear) // Ensure the background is clear
//                        .listStyle(PlainListStyle())
//                    }
//                    .background(Color.clear)
//                    .cornerRadius(10)
//                    .shadow(radius: 5)
//                    .padding(.horizontal)
//
//                    Spacer()
//                }
//            }
//        }
//    }
//}
//
//
//struct FloatingWidget: View {
//    @Binding var weddingDate: Date
//    @Binding var selectedColor: UIColor
//
//    var body: some View {
//        let daysRemaining = calculateDaysRemaining(until: weddingDate)
//
//        ZStack {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color(selectedColor))
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
//
//struct WeddingHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeddingHomeView(selectedColor: .constant(.red))
//    }
//}
