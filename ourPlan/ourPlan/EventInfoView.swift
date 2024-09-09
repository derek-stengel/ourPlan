//
//  EventInfoView.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/7/24.
//

import SwiftUI
import Foundation

struct EventInfoView: View {
    @Binding var event: Event
    @Binding var isPresented: Bool
    @State private var isEditPresented = false

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
            .navigationBarItems(
                leading: Button("Edit Event") {
                    isEditPresented = true
                },
                trailing: Button("Done") {
                    isPresented = false
                }
            )
            .sheet(isPresented: $isEditPresented) {
                EditEventView(event: $event)
            }
        }
    }
}



struct EventInfoView_Previews: PreviewProvider {
    @State static var event = Event(name: "The big thing!", date: .now, time: .now, note: "A note about the event")
    @State static var isPresented = true
    
    static var previews: some View {
        EventInfoView(event: $event, isPresented: $isPresented)
    }
}



