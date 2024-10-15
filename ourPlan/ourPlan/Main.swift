//
//  Main.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import Foundation
import SwiftUI
import SpotifyiOS

// MARK:                                       -- Future Add-ons --

// MARK: Functionality
// Be able to create and edit playlists in app. Add a search bar to allow the user to search for songs, and append them to their playlists in app.
// Google maps having correct location management. Currently returns the location lat & long / address, not the name of the location as if searched up in the first place.
// Dynamic event cells on WeddingHomeView based on ios version?
// Allow the custom filters do allow the user to change from custom string filters to color coding their events instead (either a dot as a section header or cells colored to that color at like 0.3 opacity and black text or something).

// MARK: UI Changes
// MAP:
// completely overhaul the map view
// Tab bar background (iOS 18 only)

// Spotify:
// Spotify view custom color theme in the UI?
// Have the ability for users to search by artists (have the filter button just change the searchQuery and searchResults from type Track? to type Artist? or something)


// MARK: Bug Fixes
// Event filters showing up in editEventView

enum Tab {
    case honeymoon
    case map
    case home
    case events
    case people
}

struct MainHousingView: View {
    @State private var selectedTab: Int = 2
    @Binding var selectedColor: UIColor
//    @StateObject private var eventViewModel = EventViewModel() // maybe not needed since already present in app.swift
//    @StateObject private var peopleViewModel = PeopleViewModel() // maybe not needed since already present in app.swift
    @Binding var weddingCity: String
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                SpotifyPlaylistView(userPlaylists: [], selectedColor: $selectedColor)
                    .tabItem {
                        Image(systemName: "music.quarternote.3")
                        Text("Spotify")
                    }
                    .tag(0)

                MapDisplayView(selectedColor: $selectedColor)
//                    .environmentObject(peopleViewModel)
                    .tabItem {
                        Image(systemName: "location")
                        Text("Maps")
                    }
                    .tag(1)

                WeddingHomeView(selectedColor: $selectedColor, weddingCity: $weddingCity)
//                    .environmentObject(eventViewModel)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(2)

                EventListView(selectedColor: $selectedColor)
//                    .environmentObject(eventViewModel)
                    .tabItem {
                        Image(systemName: "calendar.badge.plus")
                        Text("Events")
                    }
                    .tag(3)

                PeopleListView(selectedColor: $selectedColor)
//                    .environmentObject(peopleViewModel)
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard")
                        Text("People")
                    }
                    .tag(4)
            }
            .tint(Color.init(uiColor: selectedColor))
//            .onAppear {
//                setupTabBarAppearance()
//            }
            
        }
        .preferredColorScheme(.light)
    }
    
    // Reconfigure this after doing the map view
//    func setupTabBarAppearance() {
//        // Customize the appearance of the tab bar
//        let tabBarAppearance = UITabBarAppearance()
//        tabBarAppearance.configureWithOpaqueBackground()
//        
//        // Set the background color of the tab bar
//        tabBarAppearance.backgroundColor = UIColor.white
//        
//        // Set the color for unselected items
//        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.black
//        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
//        
//        // Set the color for selected items
//        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = selectedColor
//        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: selectedColor]
//        
//        UITabBar.appearance().standardAppearance = tabBarAppearance
//        if #available(iOS 15.0, *) {
//            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//        }
//    }
}

struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainHousingView(selectedColor: .constant(UIColor.systemCyan), weddingCity: .constant("South Jordan, UT"))
            .environmentObject(EventViewModel())
            .environmentObject(SpotifyAuthManager.shared)
            .environmentObject(PeopleViewModel())
    }
}
