//
//  EventInfoView.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/7/24.
//

import Foundation
import SwiftUI

struct EventInfoSheet: View {
    @Binding var event: Event
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var eventViewModel: EventViewModel
    @Binding var selectedColor: UIColor
    @Binding var sheetHeight: PresentationDetent
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                Text(event.name)
                    .font(.system(size: 40, design: .serif))
                    .bold()
                
                Text("Scheduled for \(formattedDateWithSuffix(from: event.date)) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
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
            .onAppear {
                refreshEventDetails()
            }
            .navigationBarItems(
                trailing: Button("Close") {
                    dismiss()
                }
            )
        }
    }
    
    private func refreshEventDetails() {
        if let updatedEvent = eventViewModel.events.first(where: { $0.id == event.id }) {
            event = updatedEvent
        }
    }
}

extension DateFormatter {
    static var fullDateWithSuffixFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }
}

func daySuffix(from day: Int) -> String {
    switch day {
    case 11, 12, 13:
        return "th"
    case _ where day % 10 == 1:
        return "st"
    case _ where day % 10 == 2:
        return "nd"
    case _ where day % 10 == 3:
        return "rd"
    default:
        return "th"
    }
}

func formattedDateWithSuffix(from date: Date) -> String {
    let calendar = Calendar.current
    let day = calendar.component(.day, from: date)
    
    let formattedDate = DateFormatter.fullDateWithSuffixFormatter.string(from: date)
    return "\(formattedDate)\(daySuffix(from: day))"
}

struct EventInfoView_Previews: PreviewProvider {
    @State static var event = Event(name: "The big thing!", date: .now, time: .now, note: "This is a note about a long bit of nothing important so yeah thats cool", filter: "")
    @State static var isPresented = true
    
    static var previews: some View {
        @State var sheetHeight = PresentationDetent.height(CGFloat(180))
        
        EventInfoSheet(event: $event, selectedColor: .constant(.red), sheetHeight: $sheetHeight)
            .environmentObject(EventViewModel())
    }
}
