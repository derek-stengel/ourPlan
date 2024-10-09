
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
    @Binding var weddingCity: String
    
    @EnvironmentObject private var eventViewModel: EventViewModel
    
    @State private var selectedEvent: Event?
    @State private var isEventInfoViewPresented = false
    @State var sheetHeight = PresentationDetent.height(CGFloat(200))
    @State private var selectedImage: UIImage? = UserDefaults.standard.getImage(forKey: "selectedWeddingImage")
    @State private var isImagePickerPresented: Bool = false
    
    init(selectedColor: Binding<UIColor>, weddingCity: Binding<String>) {
        _selectedColor = selectedColor
        _weddingCity = weddingCity
        _isNameEntryViewPresented = State(initialValue: userName.isEmpty || spouseName.isEmpty)
    }
    
    var body: some View {
        ZStack {
            if isNameEntryViewPresented {
                NameEntryView(isPresented: $isNameEntryViewPresented, selectedColor: $selectedColor)
                    .onDisappear {
                        loadProfileData()
                    }
            } else {
                VStack(spacing: 0) {
                    
                    // Top profile view
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    let daysRemaining = calculateDaysRemaining(until: weddingDate)
                                    Text(buildAttributedText(for: daysRemaining))
                                        .font(.system(size: 21, design: .serif))
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Button(action: {
                                        isProfileViewPresented.toggle()
                                    }) {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color(selectedColor))
                                            .padding(.bottom, 0)
                                    }
                                    .sheet(isPresented: $isProfileViewPresented) {
                                        ProfileView(weddingDate: $weddingDate, userName: $userName, spouseName: $spouseName, selectedColor: $selectedColor, weddingCity: $weddingCity)
                                    }
                                }
                                
                                Text("\(userName) & \(spouseName)")
                                    .font(.system(size: 40, design: .serif))
                                    .fontWeight(.bold)
                                
                                HStack {
                                    Text(formattedWeddingDate(weddingDate))
                                    Text("•")
                                    Text(weddingCity)
                                }
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(14)
                    
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        ZStack {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 400, height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding()
                            } else {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray, lineWidth: 4)
                                    .frame(width: 400, height: 180)
                                    .overlay(
                                        Text("Add Image")
                                            .foregroundColor(.gray)
                                            .font(.headline)
                                    )
                                    .padding()
                            }
                        }
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage, isPresented: $isImagePickerPresented)
                            .onDisappear {
                                if let newImage = selectedImage {
                                    UserDefaults.standard.deleteImage(forKey: "selectedWeddingImage")
                                    UserDefaults.standard.setImage(newImage, forKey: "selectedWeddingImage")
                                }
                            }
                    }
                    
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
                                            .foregroundColor(Color(selectedColor))
                                        
                                        Text(" on ")
                                            .font(.system(size: 18, design: .serif))
                                            .foregroundColor(.black)
                                        
                                        Text("\(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
                                            .font(.system(size: 18, design: .serif))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .frame(alignment: .center)
                                }
                                .padding(.horizontal)
                                .onTapGesture {
                                    selectedEvent = event
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
            loadProfileData()
        }
        .sheet(item: $selectedEvent) { event in
            let binding = Binding(
                get: { event },
                set: { selectedEvent = $0 }
            )
            
            EventInfoSheet(event: binding, selectedColor: $selectedColor, sheetHeight: $sheetHeight)
                .environmentObject(eventViewModel)
                .background(Color.white)
                .onDisappear {
                    eventViewModel.updateEvent(binding.wrappedValue)
                }
                .presentationDetents([sheetHeight], selection: $sheetHeight)
                .presentationDragIndicator(.hidden)
        }
    }
    
    private func loadProfileData() {
        userName = UserSettings.getUserName() ?? ""
        spouseName = UserSettings.getSpouseName() ?? ""
        selectedColor = UserSettings.getThemeColor()
        weddingDate = UserSettings.getWeddingDate() ?? Date()
        selectedImage = UserDefaults.standard.getImage(forKey: "selectedWeddingImage")
    }
    
    private func formattedWeddingDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d'\(daySuffix(for: date))', yyyy"
        return formatter.string(from: date)
    }
    
    private func daySuffix(for date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        switch day {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    func buildAttributedText(for daysRemaining: Int) -> AttributedString {
        var attributedString: AttributedString
        
        if daysRemaining == 0 {
            attributedString = AttributedString("Todays the day!")
        } else if daysRemaining > 0 {
            attributedString = AttributedString("\(daysRemaining) days to go!")
        } else {
            let daysSince = abs(daysRemaining)
            attributedString = AttributedString("\(daysSince) days since!")
        }
        
        if daysRemaining != 0, let range = attributedString.range(of: "\(abs(daysRemaining))") {
            attributedString[range].font = .system(size: 30, design: .serif)
        }
        
        return attributedString
    }
    
    func calculateDaysRemaining(until date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let startOfDayNow = calendar.startOfDay(for: now)
        let startOfDayWedding = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfDayNow, to: startOfDayWedding)
        return components.day ?? 0
    }
}

struct WeddingHomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        WeddingHomeView(selectedColor: .constant(.orange), weddingCity: .constant("New York, NY"))
            .environmentObject(EventViewModel())
    }
}
