//
//  Event.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/15/24.
//

import Foundation
import SwiftUI

struct Event: Identifiable {
    var id = UUID()
    var name: String
    var date: Date
    var time: Date
}
