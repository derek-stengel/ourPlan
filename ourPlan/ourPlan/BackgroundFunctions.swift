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
    
    static func saveWeddingCity(_ name: String) {
        UserDefaults.standard.set(name, forKey: "weddingCity")
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

extension UserDefaults {
    func setImage(_ image: UIImage?, forKey key: String) {
        guard let image = image else { return }

        // Get the image path
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let imagePath = getDocumentsDirectory().appendingPathComponent("\(key).jpg")
            try? imageData.write(to: imagePath)
            
            // Save the file path in UserDefaults
            set(imagePath.path, forKey: key)
        }
    }

    func getImage(forKey key: String) -> UIImage? {
        if let imagePath = string(forKey: key) {
            let url = URL(fileURLWithPath: imagePath)
            if let data = try? Data(contentsOf: url) {
                return UIImage(data: data)
            }
        }
        return nil
    }

    func deleteImage(forKey key: String) {
        if let imagePath = string(forKey: key) {
            let url = URL(fileURLWithPath: imagePath)
            try? FileManager.default.removeItem(at: url)
        }
    }

    // Helper function to get the app's documents directory
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}


//extension UserDefaults { // new
//    func setImage(_ image: UIImage?, forKey key: String) {
//        guard let image = image, let data = image.jpegData(compressionQuality: 1.0) else {
//            removeObject(forKey: key) // Remove image if nil is passed
//            return
//        }
//        set(data, forKey: key)
//    }
//    
//    func getImage(forKey key: String) -> UIImage? {
//        guard let data = data(forKey: key), let image = UIImage(data: data) else { return nil }
//        return image
//    }
//    
//    func removeImage(forKey key: String) {
//        removeObject(forKey: key) // Remove the image data from UserDefaults
//    }
//}


//extension UserDefaults { // old
//    func setImage(_ image: UIImage?, forKey key: String) {
//        guard let image = image else {
//            removeObject(forKey: key)
//            return
//        }
//        if let data = image.jpegData(compressionQuality: 1.0) {
//            set(data, forKey: key)
//        }
//    }
//    
//    func getImage(forKey key: String) -> UIImage? {
//        guard let data = data(forKey: key) else { return nil }
//        return UIImage(data: data)
//    }
//}





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
