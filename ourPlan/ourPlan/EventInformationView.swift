import SwiftUI

struct EventInformationView: View {
    @Binding var event: Event
    @EnvironmentObject var eventViewModel: EventViewModel
    @Binding var selectedColor: UIColor
    @State private var navigateToEditView = false // State to trigger navigation
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: 25) {
                    Text(event.name.trimmingCharacters(in: .whitespaces))
                        .font(.system(size: 40, design: .serif))
                        .bold()
                    
                    Text("Event date: \(formattedDateWithSuffix(from: event.date))")
                        .font(.system(size: 20, design: .serif))
                    
                    Text("Reminder scheduled for \(event.time, formatter: DateFormatter.shortTimeFormatter)")
                        .font(.system(size: 16, design: .serif))
                    
                    if !event.note.isEmpty {
                        Text(event.note.trimmingCharacters(in: .whitespaces))
                            .font(.system(size: 14, design: .serif))
                            .background(Color.gray.opacity(0.1).cornerRadius(8).padding(-5))
                    } else {
                        Text(event.note.trimmingCharacters(in: .whitespaces))
                            .font(.system(size: 14, design: .serif))
                    }
                    
                    Spacer() // Pushes the content above to top and prevents from squishing too close
                }
                .padding()
            }
            Button(action: {
                navigateToEditView = true // Trigger navigation when button is tapped
            }) {
                Text("Edit Event")
                    .font(.system(size: 20, design: .serif))
                    .foregroundColor(Color(selectedColor))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle()) // Make the entire area tappable
            }
            .sheet(isPresented: $navigateToEditView) {
                EditEventView(event: $event, selectedColor: $selectedColor)
            }
            .padding(.bottom, 20) // Add some padding above the tab bar for better spacing
        }
        .onAppear {
            refreshEventDetails()
        }
    }
    
    private func refreshEventDetails() {
        if let updatedEvent = eventViewModel.events.first(where: { $0.id == event.id }) {
            event = updatedEvent
        }
    }
}

struct EventInformationView_Preview: PreviewProvider {
    @State static var event = Event(name: "123456789012345", date: .now, time: .now, note: "This is a note about a long bit of nothing important so yeah thats cool", filter: "")
    
    static var previews: some View {
        EventInformationView(event: $event, selectedColor: .constant(.red))
            .environmentObject(EventViewModel())
    }
}

//import SwiftUI
//
//struct EventInformationView: View {
//    @Binding var event: Event
//    @EnvironmentObject var eventViewModel: EventViewModel
//    @Binding var selectedColor: UIColor
//    @State private var navigateToEditView = false // State to trigger navigation
//
//    var body: some View {
//        VStack(alignment: .center, spacing: 20) {
//            Text(event.name)
//                .font(.system(size: 40, design: .serif))
//                .bold()
//
//            Text("Event date: \(formattedDateWithSuffix(from: event.date))")
//                .font(.system(size: 20, design: .serif))
//
//            Text("Reminder scheduled for \(formattedDateWithSuffix(from: event.date)) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
//                .font(.system(size: 16, design: .serif))
//
//            if !event.note.isEmpty {
//                Text(event.note)
//                    .font(.system(size: 14, design: .serif))
//                    .background(Color.gray.opacity(0.1).cornerRadius(8).padding(-5))
//            } else {
//                Text(event.note)
//                    .font(.system(size: 14, design: .serif))
//            }
//
//            ZStack {
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color(selectedColor))
//                    .opacity(0.8)
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 50)
//
//                Button(action: {
//                    navigateToEditView = true // Trigger navigation when button is tapped
//                }) {
//                    Text("Edit Event")
//                        .foregroundColor(.black) // Ensure the text contrasts with the background
//                        .bold()
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .contentShape(Rectangle()) // Make the entire area tappable
//                }
//                .buttonStyle(PlainButtonStyle()) // Avoid default button styling
//            }
//
//            // Navigate to EditEventView using a sheet or fullScreenCover for a modal-like presentation
//            .sheet(isPresented: $navigateToEditView) {
//                EditEventView(event: $event, selectedColor: $selectedColor)
//            }
//        }
//
//        .padding()
//        .onAppear {
//            refreshEventDetails()
//        }
//    }
//
//    private func refreshEventDetails() {
//        if let updatedEvent = eventViewModel.events.first(where: { $0.id == event.id }) {
//            event = updatedEvent
//        }
//    }
//}
//
//struct EventInformationView_Preview: PreviewProvider {
//    @State static var event = Event(name: "123456789012345", date: .now, time: .now, note: "This is a note about a long bit of nothing important so yeah thats cool", filter: "")
//    @State static var isPresented = true
//
//    static var previews: some View {
//        @State var sheetHeight = PresentationDetent.height(CGFloat(180))
//
//        EventInformationView(event: $event, selectedColor: .constant(.red))
//            .environmentObject(EventViewModel())
//    }
//}
