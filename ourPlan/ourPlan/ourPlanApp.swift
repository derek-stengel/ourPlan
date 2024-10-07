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
    @State private var weddingCity: String = "New York, NY"
    
    init() {
        requestNotificationAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeContentView(selectedColor: $selectedColor, weddingCity: $weddingCity)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(eventViewModel)
                .environmentObject(PeopleViewModel())
                .environmentObject(authManager)
                .onOpenURL { url in
                    SpotifyAuthManager.shared.handleCallback(url: url)
                }
                .onAppear {
                    eventViewModel.loadEvents()
                }
        }
    }
}

// The purpose of this app is to help organize your wedding in one place, from notifications, to easily messaging large groups, to building your ideal spotify playlist. 
