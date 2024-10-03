//
//  Main.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import Foundation
import SwiftUI
import SpotifyiOS

enum Tab {
    case honeymoon
    case map
    case home
    case events
    case people
}

struct HomeContentView: View {
    @State private var selectedTab: Int = 2 // controls which tab displays upon app launch
    @Binding var selectedColor: UIColor
    @StateObject private var eventViewModel = EventViewModel()
    
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

                WeddingHomeView(selectedColor: $selectedColor)
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
        HomeContentView(selectedColor: .constant(UIColor.systemCyan))
            .environmentObject(EventViewModel())
            .environmentObject(SpotifyAuthManager.shared)
    }
}
