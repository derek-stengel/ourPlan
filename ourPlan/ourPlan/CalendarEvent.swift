//
//  CalendarEvent.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation

struct Event: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
}

