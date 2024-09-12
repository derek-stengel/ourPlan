//
//  Event.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/15/24.
//

import Foundation
import SwiftUI

struct Event: Identifiable, Codable {
    var id = UUID()
    var name: String
    var date: Date
    var time: Date
    var note: String
}
