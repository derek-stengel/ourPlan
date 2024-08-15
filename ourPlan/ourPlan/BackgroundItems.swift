//
//  BackgroundItems.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/9/24.
//

import Foundation

struct UserSettings {
    static func getUserName() -> String? {
        UserDefaults.standard.string(forKey: "userName")
    }
    
    static func getSpouseName() -> String? {
        UserDefaults.standard.string(forKey: "spouseName")
    }
    
    static func saveUserName(_ name: String) {
        UserDefaults.standard.set(name, forKey: "userName")
    }
    
    static func saveSpouseName(_ name: String) {
        UserDefaults.standard.set(name, forKey: "spouseName")
    }
}
