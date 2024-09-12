//
//  ourPlanApp.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import SwiftUI

@main
struct ourPlanApp: App {
    @StateObject private var authManager = SpotifyAuthManager.shared
    @State private var selectedColor: UIColor = .systemIndigo
    @StateObject private var eventViewModel = EventViewModel()
    
    init() {
        requestNotificationAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeContentView(selectedColor: $selectedColor)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(eventViewModel) // Pass the view model to the environment
                .environmentObject(authManager) // Pass the authManager to the environment
                .onOpenURL { url in
                    SpotifyAuthManager.shared.handleCallback(url: url)
                }
                .onAppear {
                    // Ensure event data is loaded when the app launches
                    eventViewModel.loadEvents()
                }
        }
    }
}

// The purpose of this app is to help organize your wedding in one place, from notifications, to easily messaging large groups, to building your ideal spotify playlist. 
