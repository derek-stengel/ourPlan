//
//  EventInfoView.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/7/24.
//

import SwiftUI

struct EventInfoView: View {
    @Binding var event: Event
    @Binding var isPresented: Bool
    @State private var isEditPresented = false // No longer needed, can be removed
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var eventViewModel: EventViewModel // Use environment object if needed

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                Spacer().frame(height: 10)
                Text(event.name)
                    .font(.largeTitle)
                    .bold()
                
                Text("Scheduled for \(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
                    .font(.headline)
                
                Spacer()
            }
            .padding()
            .onAppear {
                // Refresh or update event details here if necessary
                refreshEventDetails()
            }
            .navigationBarItems(
                leading: NavigationLink("Edit Event") {
                    EditEventView(event: $event)
                },
                trailing: Button("Done") {
                    isPresented = false
                }
            )
        }
        .navigationBarItems(trailing: Button("Done") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private func refreshEventDetails() {
        // Example logic to refresh event details from the view model
        if let updatedEvent = eventViewModel.events.first(where: { $0.id == event.id }) {
            event = updatedEvent
        }
    }
}


struct EventInfoView_Previews: PreviewProvider {
    @State static var event = Event(name: "The big thing!", date: .now, time: .now, note: "A note about the event")
    @State static var isPresented = true
    
    static var previews: some View {
        EventInfoView(event: $event, isPresented: $isPresented)
            .environmentObject(EventViewModel())
    }
}

////
////  EventInfoView.swift
////  ourPlan
////
////  Created by Derek Stengel on 9/7/24.
////
//
//import SwiftUI
//import Foundation
//
//struct EventInfoView: View {
//    @Binding var event: Event
//    @Binding var isPresented: Bool
//    @State private var isEditPresented = false
//    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var eventViewModel: EventViewModel // Use environment object if needed
//
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .center, spacing: 20) {
//                Spacer().frame(height: 10)
//                Text(event.name)
//                    .font(.largeTitle)
//                    .bold()
//                
//                Text("Scheduled for \(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
//                    .font(.headline)
//                
//                Spacer()
//            }
//            .padding()
//            .onAppear {
//                // Refresh or update event details here if necessary
//                refreshEventDetails()
//            }
//            .navigationBarItems(
//                leading: Button("Edit Event") {
//                    isEditPresented = true
//                },
//                trailing: Button("Done") {
//                    isPresented = false
//                }
//            )
//            .sheet(isPresented: $isEditPresented) {
//                EditEventView(event: $event)
//            }
//        }
//        .navigationBarItems(trailing: Button("Done") {
//            presentationMode.wrappedValue.dismiss()
//        })
//    }
//    
//    private func refreshEventDetails() {
//        // Example logic to refresh event details from the view model
//        if let updatedEvent = eventViewModel.events.first(where: { $0.id == event.id }) {
//            event = updatedEvent
//        }
//    }
//}
//
//struct EventInfoView_Previews: PreviewProvider {
//    @State static var event = Event(name: "The big thing!", date: .now, time: .now, note: "A note about the event")
//    @State static var isPresented = true
//    
//    static var previews: some View {
//        EventInfoView(event: $event, isPresented: $isPresented)
//            .environmentObject(EventViewModel())
//    }
//}
