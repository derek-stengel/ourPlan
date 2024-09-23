//
//  Event.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/15/24.
//

import Foundation

struct Event: Identifiable, Codable {
    var id = UUID()
    var name: String
    var date: Date
    var time: Date
    var note: String
    var filter: String
    
    static var defaultFilters: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: "defaultFilters") ?? ["IMPORTANT", "Design", "Catering"]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "defaultFilters")
        }
    }
}
