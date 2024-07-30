//
//  CalendarDisplayView.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation
import SwiftUI

struct CalendarDisplayView: View {
    @StateObject private var viewModel = PeopleViewModel()
    @State private var showingAddEvent = false
    @State private var selectedDate: Date? = nil

    var body: some View {
        NavigationView { // Add NavigationView here
            VStack {
                Text("Calendar")
                    .font(.largeTitle)
                    .padding()
                CalendarView(viewModel: viewModel, selectedDate: $selectedDate)
                    .frame(height: 400) // Adjust the height as needed
                if let date = selectedDate, !viewModel.events(for: date).isEmpty {
                    List {
                        ForEach(viewModel.events(for: date)) { event in
                            Text(event.title)
                        }
                        .onDelete { offsets in
                            viewModel.deleteEvent(at: offsets)
                        }
                    }
                } else {
                    Text("No events for selected date")
                        .padding()
                }
            }
            .padding()
//            .background(Color.gray.edgesIgnoringSafeArea(.all)) // Set background color to grey
            .navigationBarItems(trailing: Button(action: {
                showingAddEvent = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddEvent) {
                if let date = selectedDate {
                    AddEventView(viewModel: viewModel, date: date)
                } else {
                    AddEventView(viewModel: viewModel)
                }
            }
        }
    }
}
