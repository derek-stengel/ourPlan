//
//  Person.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation
import SwiftUI
import Contacts

struct Person: Identifiable {
    let id = UUID()
    var name: String
    var job: String
}

