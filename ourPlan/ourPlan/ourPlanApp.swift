//
//  ourPlanApp.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import SwiftUI

@main
struct ourPlanApp: App {
    @State private var selectedColor: UIColor = .systemIndigo
    
    init() {
        requestNotificationAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeContentView(selectedColor: $selectedColor)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .onOpenURL(perform: { url in
                    SpotifyAuthManager.shared.handleCallback(url: url)
                })
        }
    }
}

// This app idea is for all the wedding planners out there. I recently got married, and I know the stress behind putting everything together, making sure important events are taken care of, guest lists, catering, a playlist? That's just the start.

// Having everything in one, simplified place would save time, money, and worry. This app would allow this to happen in the simpliest way possible. There could be a screen for goal tracking with a progress bar, another screen with a map that shows venues and catering options, another screen where you can input emails or phone numbers to send out a mass text, etc.
