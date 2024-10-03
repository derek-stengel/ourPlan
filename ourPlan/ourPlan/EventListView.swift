//
//  EventListView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/15/24.
//

import SwiftUI

struct EventListView: View {
    @EnvironmentObject var eventViewModel: EventViewModel
    @State private var showingAddEvent = false
    @State private var showingFiltersView = false
    @Binding var selectedColor: UIColor
    @State private var filters = Event.defaultFilters

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(groupedEventKeys, id: \.self) { key in
                        Section(header: Text(key)
                                    .font(.headline)
                                    .foregroundColor(.blue)) {
                            eventList(for: key)
                        }
                    }
                }
                .navigationTitle("Events")
                .navigationBarItems(
                    leading: Button(action: {
                        showingFiltersView.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                    },
                    trailing: addButton
                )
                .sheet(isPresented: $showingFiltersView) {
                    ManageFiltersView(filters: $filters, selectedColor: $selectedColor)
                }
                .sheet(isPresented: $showingAddEvent) {
                    AddEventView(viewModel: eventViewModel, selectedColor: $selectedColor)
                }
            }
            .onAppear {
                filters = Event.defaultFilters
            }
        }
    }

    private func eventList(for key: String) -> some View {
        ForEach(groupedEvents[key] ?? []) { event in
            NavigationLink(destination: EventInformationView(event: Binding(
                get: { event },
                set: { updatedEvent in
                    if let index = eventViewModel.events.firstIndex(where: { $0.id == event.id }) {
                        eventViewModel.events[index] = updatedEvent
                    }
                }), selectedColor: $selectedColor)) {
                VStack(alignment: .leading) {
                    Text(event.name)
                        .font(.headline)
                    Text("Reminder on \(event.date, formatter: DateFormatter.shortDateFormatter) at \(event.time, formatter: DateFormatter.shortTimeFormatter)")
                        .font(.subheadline)
                }
            }
            .swipeActions {
                Button(role: .destructive) {
                    if let index = eventViewModel.events.firstIndex(where: { $0.id == event.id }) {
                        eventViewModel.deleteEvent(at: IndexSet(integer: index))
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
    
    private var addButton: some View {
        Button(action: {
            showingAddEvent = true
        }) {
            Image(systemName: "plus")
        }
    }

    private var groupedEvents: [String: [Event]] {
        Dictionary(grouping: eventViewModel.events, by: { $0.filter })
    }

    private var groupedEventKeys: [String] {
        groupedEvents.keys.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }) // sorts filters a-z order
    }

    private func moveEvent(from source: IndexSet, to destination: Int) {
        eventViewModel.events.move(fromOffsets: source, toOffset: destination)
    }
}


// MARK: - DateFormatter Extensions
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
