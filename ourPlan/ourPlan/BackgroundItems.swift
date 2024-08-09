//
//  BackgroundItems.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/9/24.
//

import Foundation

struct UserDefaultsKeys {
    static let userName = "userName"
    static let spouseName = "spouseName"
}

class UserSettings {
    static func saveUserName(_ name: String) {
        UserDefaults.standard.set(name, forKey: UserDefaultsKeys.userName)
    }

    static func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.userName)
    }

    static func saveSpouseName(_ name: String) {
        UserDefaults.standard.set(name, forKey: UserDefaultsKeys.spouseName)
    }

    static func getSpouseName() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.spouseName)
    }
}
