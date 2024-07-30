//
//  CalendarView.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import SwiftUI
import FSCalendar

struct CalendarView: UIViewRepresentable {
    @ObservedObject var viewModel: PeopleViewModel
    @Binding var selectedDate: Date?

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarView

        init(_ parent: CalendarView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }

        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            return parent.viewModel.events(for: date).count
        }

        func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
            let events = parent.viewModel.events(for: date)
            return events.first?.title
        }
    }
}
