//
//  EventListView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/15/24.
//

import Foundation
import SwiftUI

struct EventListView: View {
    @EnvironmentObject var eventViewModel: EventViewModel
    @State private var showingAddEvent = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach($eventViewModel.events) { $event in
                        NavigationLink(destination: EditEventView(event: $event)) {
                            VStack(alignment: .leading) {
                                Text(event.name)
                                    .font(.headline)
                                Text("Reminder on \(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: eventViewModel.deleteEvent)
                    .onMove(perform: moveEvent)
                }
                .navigationTitle("Events")
                .font(.system(size: 18, design: .serif))
                
            }
            .navigationBarItems(leading: HStack {
                EditButton()
            },
                                trailing: Button(action: {
                showingAddEvent = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddEvent) {
                AddEventView(viewModel: eventViewModel)
            }
        }
    }
    
    private func moveEvent(from source: IndexSet, to destination: Int) {
        eventViewModel.events.move(fromOffsets: source, toOffset: destination)
    }
}

extension DateFormatter {
    static var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    static var shortTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

//import Foundation
//import SwiftUI
//
//struct EventListView: View {
//    @EnvironmentObject var eventViewModel: EventViewModel
//    @State private var showingAddEvent = false
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    ForEach($eventViewModel.events) { $event in
//                        NavigationLink(destination: EditEventView(event: $event)) {
//                            VStack(alignment: .leading) {
//                                Text(event.name)
//                                    .font(.headline)
//                                Text("Reminder on \(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
//                                    .font(.subheadline)
//                            }
//                        }
//                    }
//                    .onDelete(perform: eventViewModel.deleteEvent)
//                    .onMove(perform: moveEvent)
//                }
//                .navigationTitle("Events")
//                .font(.system(size: 18, design: .serif))
//                
//            }
//            .navigationBarItems(leading: HStack {
//                EditButton()
//            },
//                                trailing: Button(action: {
//                showingAddEvent = true
//            }) {
//                Image(systemName: "plus")
//            })
//            .sheet(isPresented: $showingAddEvent) {
//                AddEventView(viewModel: eventViewModel)
//            }
//        }
//    }
//    
//    private func moveEvent(from source: IndexSet, to destination: Int) {
//        eventViewModel.events.move(fromOffsets: source, toOffset: destination)
//    }
//}
//
//extension DateFormatter {
//    static var shortDateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        return formatter
//    }
//    
//    static var shortTimeFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        return formatter
//    }
//}
