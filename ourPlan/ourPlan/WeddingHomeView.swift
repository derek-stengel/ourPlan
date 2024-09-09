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
    @State private var weddingDate: Date = UserSettings.getWeddingDate() ?? Date()
    @State private var userName: String = UserSettings.getUserName() ?? ""
    @State private var spouseName: String = UserSettings.getSpouseName() ?? ""
    @Binding private var selectedColor: UIColor

    @EnvironmentObject private var eventViewModel: EventViewModel
    
    @State private var selectedEvent: Event?
    @State private var isEventInfoViewPresented = false

    init(selectedColor: Binding<UIColor>) {
        _selectedColor = selectedColor
        _isNameEntryViewPresented = State(initialValue: userName.isEmpty || spouseName.isEmpty)
    }

    var body: some View {
        ZStack {
            if isNameEntryViewPresented {
                NameEntryView(isPresented: $isNameEntryViewPresented, selectedColor: $selectedColor)
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
                        
                        FloatingWidget(weddingDate: $weddingDate, selectedColor: $selectedColor)
                            .frame(width: 300, height: 160)
                            .shadow(radius: 10)
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
                                .font(.system(size: 25, design: .serif))
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
                                    
                                    HStack(spacing: 0) {
                                        Text(event.name.trimmingCharacters(in: .whitespaces))
                                            .font(.system(size: 18, design: .serif))
                                            .foregroundColor(Color(selectedColor)) // Name in selected color
                                        
                                        Text(" on ")
                                            .font(.system(size: 18, design: .serif))
                                            .foregroundColor(.black)
                                        
                                        Text("\(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
                                            .font(.system(size: 18, design: .serif))
                                            .foregroundColor(.black) // Date and Time in black color
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .frame(alignment: .center)
                                }
                                .padding(.horizontal)
                                .onTapGesture {
                                    selectedEvent = event
                                    isEventInfoViewPresented.toggle()
                                }
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
        .onAppear {
            // Load profile data when the view appears
            loadProfileData()
        }
        .sheet(isPresented: $isEventInfoViewPresented) {
            if let binding = selectedEventBinding {
                EventInfoView(event: binding, isPresented: $isEventInfoViewPresented)
                    .onDisappear {
                        eventViewModel.updateEvent(binding.wrappedValue)
                    }
            } else {
                Text("No event selected.")
            }
        }
    }

    private var selectedEventBinding: Binding<Event>? {
        guard let selectedEvent = selectedEvent else {
            return nil
        }
        return Binding(
            get: { selectedEvent },
            set: { self.selectedEvent = $0 }
        )
    }

    private func loadProfileData() {
        userName = UserSettings.getUserName() ?? ""
        spouseName = UserSettings.getSpouseName() ?? ""
        selectedColor = UserSettings.getThemeColor()
        weddingDate = UserSettings.getWeddingDate() ?? Date()
    }
}

struct FloatingWidget: View {
    @Binding var weddingDate: Date
    @Binding var selectedColor: UIColor

    var body: some View {
        let daysRemaining = calculateDaysRemaining(until: weddingDate)

        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(selectedColor))
                .frame(width: 300, height: 150)
                .rotatingGradientBorderTwo(selectedColor: $selectedColor)

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
        WeddingHomeView(selectedColor: .constant(.orange))
            .environmentObject(EventViewModel())
    }
}


////
////  WeddingHomeView.swift
////  ourPlan
////
////  Created by Derek Stengel on 8/9/24.
////
//
//import SwiftUI
//
//struct WeddingHomeView: View {
//    @State private var isProfileViewPresented = false
//    @State private var isNameEntryViewPresented = false
//    @State private var weddingDate: Date = UserSettings.getWeddingDate() ?? Date()
//    @State private var userName: String = UserSettings.getUserName() ?? ""
//    @State private var spouseName: String = UserSettings.getSpouseName() ?? ""
//    @Binding private var selectedColor: UIColor
//
//    @EnvironmentObject private var eventViewModel: EventViewModel
//    
//    @State private var selectedEvent: Event?
//// State<Event?> -> Binding<Event>
//    // $selectedEvent == Binding<Event?>
//    @State private var isEventInfoViewPresented = false
//
//    init(selectedColor: Binding<UIColor>) {
//        _selectedColor = selectedColor
//        _isNameEntryViewPresented = State(initialValue: userName.isEmpty || spouseName.isEmpty)
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
//                        
//                        FloatingWidget(weddingDate: $weddingDate, selectedColor: $selectedColor)
//                            .frame(width: 300, height: 160)
//                            .shadow(radius: 10)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    .padding()
//                    
//                    // Display upcoming events
//                    VStack(alignment: .center, spacing: 12) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color(selectedColor))
//                                .opacity(0.3)
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 50)
//                            Text("Upcoming Events")
//                                .font(.system(size: 25, design: .serif))
//                                .fontWeight(.light)
//                                .padding(.horizontal)
//                        }
//                        if eventViewModel.nextThreeEvents.isEmpty {
//                            Text("No upcoming events")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                                .padding(.horizontal)
//                        } else {
//                            ForEach(eventViewModel.nextThreeEvents) { event in
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .fill(.ultraThinMaterial)
//                                        .frame(maxWidth: .infinity)
//                                        .frame(height: 50)
//                                    
//                                    HStack(spacing: 0) {
//                                        Text(event.name.trimmingCharacters(in: .whitespaces))
//                                            .font(.system(size: 18, design: .serif))
//                                            .foregroundColor(Color(selectedColor)) // Name in selected color
//                                        
//                                        Text(" on ")
//                                            .font(.system(size: 18, design: .serif))
//                                            .foregroundColor(.black)
//                                        
//                                        Text("\(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
//                                            .font(.system(size: 18, design: .serif))
//                                            .foregroundColor(.black) // Date and Time in black color
//                                    }
//                                    .padding(.horizontal)
//                                    .padding(.vertical, 8)
//                                    .frame(alignment: .center)
//                                }
//                                .padding(.horizontal)
//                                .onTapGesture {
//                                    selectedEvent = event
//                                    isEventInfoViewPresented.toggle()
//                                }
//                            }
//                        }
//                    }
//                    .padding(.top)
//                }
//                .frame(maxHeight: .infinity, alignment: .top)
//                Spacer()
//            }
//        }
//        .background(Color.white)
//        .onAppear {
//            // Load profile data when the view appears
//            loadProfileData()
//        }
//        .sheet(isPresented: $isEventInfoViewPresented) {
//                    if let selectedEvent = $selectedEvent {
//                        EventInfoView(event: .constant(selectedEvent), isPresented: $isEventInfoViewPresented)
//                            .onDisappear {
//                                eventViewModel.updateEvent(selectedEvent)
//                            }
//                    } else {
//                        Text("IM NOT HERE!!!")
//                    }
//                }
//            }
//
//    private func loadProfileData() {
//        userName = UserSettings.getUserName() ?? ""
//        spouseName = UserSettings.getSpouseName() ?? ""
//        selectedColor = UserSettings.getThemeColor()
//        weddingDate = UserSettings.getWeddingDate() ?? Date()
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
//                .rotatingGradientBorderTwo(selectedColor: $selectedColor)
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
//        WeddingHomeView(selectedColor: .constant(.orange))
//            .environmentObject(EventViewModel())
//    }
//}


////
////  WeddingHomeView.swift
////  ourPlan
////
////  Created by Derek Stengel on 8/9/24.
////
//
//import SwiftUI
//
//struct WeddingHomeView: View {
//    @State private var isProfileViewPresented = false
//    @State private var isNameEntryViewPresented = false
//    @State private var weddingDate: Date = UserSettings.getWeddingDate() ?? Date()
//    @State private var userName: String = UserSettings.getUserName() ?? ""
//    @State private var spouseName: String = UserSettings.getSpouseName() ?? ""
//    @Binding private var selectedColor: UIColor
//
//    @EnvironmentObject private var eventViewModel: EventViewModel
//    
//    @State private var selectedEvent: Event?
//    @State private var isEventInfoViewPresented = false
//
//    init(selectedColor: Binding<UIColor>) {
//        _selectedColor = selectedColor
//        _isNameEntryViewPresented = State(initialValue: userName.isEmpty || spouseName.isEmpty)
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
//                        
//                        FloatingWidget(weddingDate: $weddingDate, selectedColor: $selectedColor)
//                            .frame(width: 300, height: 160)
//                            .shadow(radius: 10)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    .padding()
//                    
//                    // Display upcoming events
//                    VStack(alignment: .center, spacing: 12) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color(selectedColor))
//                                .opacity(0.3)
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 50)
//                            Text("Upcoming Events")
//                                .font(.system(size: 25, design: .serif))
//                                .fontWeight(.light)
//                                .padding(.horizontal)
//                        }
//                        if eventViewModel.nextThreeEvents.isEmpty {
//                            Text("No upcoming events")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                                .padding(.horizontal)
//                        } else {
//                            ForEach(eventViewModel.nextThreeEvents) { event in
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .fill(.ultraThinMaterial)
//                                        .frame(maxWidth: .infinity)
//                                        .frame(height: 50)
//                                    
//                                    HStack(spacing: 0) {
//                                        Text(event.name.trimmingCharacters(in: .whitespaces))
//                                            .font(.system(size: 18, design: .serif))
//                                            .foregroundColor(Color(selectedColor)) // Name in selected color
//                                        
//                                        Text(" on ")
//                                            .font(.system(size: 18, design: .serif))
//                                            .foregroundColor(.black)
//                                        
//                                        Text("\(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
//                                            .font(.system(size: 18, design: .serif))
//                                            .foregroundColor(.black) // Date and Time in black color
//                                    }
//                                    .padding(.horizontal)
//                                    .padding(.vertical, 8)
//                                    .frame(alignment: .center)
//                                }
//                                .padding(.horizontal)
//                                .onTapGesture {
//                                    selectedEvent = event
//                                    isEventInfoViewPresented.toggle()
//                                }
//                            }
//                        }
//                    }
//                    .padding(.top)
//                }
//                .frame(maxHeight: .infinity, alignment: .top)
//                Spacer()
//            }
//        }
//        .background(Color.white)
//        .onAppear {
//            // Load profile data when the view appears
//            loadProfileData()
//        }
//        .sheet(isPresented: $isEventInfoViewPresented) {
//                    if let selectedEvent = selectedEvent {
//                        EventInfoView(event: .constant(selectedEvent), isPresented: $isEventInfoViewPresented)
//                            .onDisappear {
//                                eventViewModel.updateEvent(selectedEvent)
//                            }
//                    } else {
//                        Text("IM NOT HERE!!!")
//                    }
//                }
//            }
//
//    private func loadProfileData() {
//        userName = UserSettings.getUserName() ?? ""
//        spouseName = UserSettings.getSpouseName() ?? ""
//        selectedColor = UserSettings.getThemeColor()
//        weddingDate = UserSettings.getWeddingDate() ?? Date()
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
//                .rotatingGradientBorderTwo(selectedColor: $selectedColor)
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
//        WeddingHomeView(selectedColor: .constant(.orange))
//            .environmentObject(EventViewModel())
//    }
//}
