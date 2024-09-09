//
//  BackgroundFunctions.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/9/24.
//

import Foundation
import UIKit
import UserNotifications

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
    
    static func saveThemeColor(_ color: UIColor) {
        UserDefaults.standard.setColor(color, forKey: "themeColor")
    }

    static func getThemeColor() -> UIColor {
        return UserDefaults.standard.colorForKey("themeColor") ?? .systemIndigo
    }
    
    static func saveWeddingDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: "weddingDate")
    }

    static func getWeddingDate() -> Date? {
        return UserDefaults.standard.object(forKey: "weddingDate") as? Date
    }
}

func requestNotificationAuthorization() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Notification permission granted.")
        } else if let error = error {
            print("Notification permission denied: \(error.localizedDescription)")
        }
    }
}

// UserDefaults Extension for UIColor
extension UserDefaults {
    func setColor(_ color: UIColor?, forKey key: String) {
        guard let color = color else { return }
        let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        set(data, forKey: key)
    }

    func colorForKey(_ key: String) -> UIColor? {
        guard let data = data(forKey: key),
              let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor else { return nil }
        return color
    }
}



//import Foundation
//import UIKit
//import UserNotifications
//
//struct UserSettings {
//    static func getUserName() -> String? {
//        UserDefaults.standard.string(forKey: "userName")
//    }
//    
//    static func getSpouseName() -> String? {
//        UserDefaults.standard.string(forKey: "spouseName")
//    }
//    
//    static func saveUserName(_ name: String) {
//        UserDefaults.standard.set(name, forKey: "userName")
//    }
//    
//    static func saveSpouseName(_ name: String) {
//        UserDefaults.standard.set(name, forKey: "spouseName")
//    }
//    
//    static func saveThemeColor(_ color: UIColor) {
//        UserDefaults.standard.setColor(color, forKey: "themeColor")
//    }
//
//    static func getThemeColor() -> UIColor {
//        return UserDefaults.standard.colorForKey("themeColor") ?? .systemIndigo
//    }
//}
//
//func requestNotificationAuthorization() {
//    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//        if granted {
//            print("Notification permission granted.")
//        } else if let error = error {
//            print("Notification permission denied: \(error.localizedDescription)")
//        }
//    }
//}
//
//
//// UserDefaults Extension for UIColor
//extension UserDefaults {
//    func setColor(_ color: UIColor?, forKey key: String) {
//        guard let color = color else { return }
//        let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
//        set(data, forKey: key)
//    }
//
//    func colorForKey(_ key: String) -> UIColor? {
//        guard let data = data(forKey: key),
//              let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor else { return nil }
//        return color
//    }
//}
