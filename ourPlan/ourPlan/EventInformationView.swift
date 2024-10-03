import SwiftUI

struct EventInformationView: View {
    @Binding var event: Event
    @EnvironmentObject var eventViewModel: EventViewModel
    @Binding var selectedColor: UIColor
    @State private var navigateToEditView = false
    
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
                    
                    Spacer()
                }
                .padding()
            }
            Button(action: {
                navigateToEditView = true
            }) {
                Text("Edit Event")
                    .font(.system(size: 20, design: .serif))
                    .foregroundColor(Color(selectedColor))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
            }
            .sheet(isPresented: $navigateToEditView) {
                EditEventView(event: $event, selectedColor: $selectedColor)
            }
            .padding(.bottom, 20)
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
