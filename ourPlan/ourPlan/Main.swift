//
//  Main.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import Foundation
import SwiftUI
import SpotifyiOS

// future implimenation: be able to click on POIs on the map and have a small info view come up (kinda like eventInfoView, just a small popup), and on that view have a plus button that takes the title, phone number, and address, and creates a contact for them.

enum Tab {
    case honeymoon
    case map
    case home
    case events
    case people
}

struct HomeContentView: View {
    @State private var selectedTab: Int = 2
    @Binding var selectedColor: UIColor
    @StateObject private var eventViewModel = EventViewModel()
    @Binding var weddingCity: String
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                SpotifyPlaylistView(selectedColor: $selectedColor)
                    .tabItem {
                        Image(systemName: "music.quarternote.3")
                        Text("Spotify")
                    }
                    .tag(0)

                MapDisplayView(selectedColor: $selectedColor)
                    .tabItem {
                        Image(systemName: "location")
                        Text("Maps")
                    }
                    .tag(1)

                WeddingHomeView(selectedColor: $selectedColor, weddingCity: $weddingCity)
                    .environmentObject(eventViewModel)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(2)

                EventListView(selectedColor: $selectedColor)
                    .environmentObject(eventViewModel)
                    .tabItem {
                        Image(systemName: "calendar.badge.plus")
                        Text("Events")
                    }
                    .tag(3)

                PeopleListView(selectedColor: $selectedColor)
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard")
                        Text("People")
                    }
                    .tag(4)
            }
            .tint(Color.init(uiColor: selectedColor))
        }
        .preferredColorScheme(.light)
    }
}

struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeContentView(selectedColor: .constant(UIColor.systemCyan), weddingCity: .constant("South Jordan, UT"))
            .environmentObject(EventViewModel())
            .environmentObject(SpotifyAuthManager.shared)
    }
}
