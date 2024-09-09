//
//  hexExtension.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/3/24.
//

import Foundation
import UIKit
import SwiftUI

extension Color {
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        let red, green, blue: Double
        switch hexString.count {
        case 6:
            red = Double((rgb >> 16) & 0xFF) / 255.0
            green = Double((rgb >> 8) & 0xFF) / 255.0
            blue = Double(rgb & 0xFF) / 255.0
        case 8: // Hex with alpha
            red = Double((rgb >> 24) & 0xFF) / 255.0
            green = Double((rgb >> 16) & 0xFF) / 255.0
            blue = Double((rgb >> 8) & 0xFF) / 255.0
        default:
            red = 0
            green = 0
            blue = 0
        }
        self.init(red: red, green: green, blue: blue)
    }
}
