//
//  ourPlanApp.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import SwiftUI

@main
struct ourPlanApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

// This app idea is for all the wedding planners out there. I recently got married, and I know the stress behind putting everything together, making sure venues are reserved, catering, guest lists, flowers, registry, the list goes on.

// Having everything in one, simplified place would save time, money, and worry. This app would allow this to happen for the first time on the App Store! There could be a screen for goal tracking with a progress bar, another screen with a map that shows venues and catering options, another screen where you can input emails or phone numbers to send out a mass text, etc.
