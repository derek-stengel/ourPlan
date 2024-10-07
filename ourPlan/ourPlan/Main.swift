//
//  Main.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import Foundation
import SwiftUI
import SpotifyiOS

// contacts created via the LocationInfoView's plus (addPersonView) don't appear in PeopleListView in real time, even with an environment object
// add a button to LocationInfoView that allows the user to press a button and launch Google Maps with the coordinates

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
                    .environmentObject(PeopleViewModel()) // maybe ?
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
                    .environmentObject(PeopleViewModel()) // maybe?
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
            .environmentObject(PeopleViewModel())
    }
}
