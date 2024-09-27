//
//  Main.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import Foundation
import SwiftUI
import SpotifyiOS

// TO DO LIST
// ADD A TAB BAR BACKGROUND

// BUG FIXES
// fix the button on peopleListView that takes the user to iMessages: the contact doesnt get taken the first time, you have to deselected a contact, then reselect one, then it will grab ALL the selected contacts. Maybe update the binding or the state, or refresh so it collects the selected contacts before opening the sheet?

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
                        Image(systemName: "music.note")
                    }
                    .tag(0)

                MapDisplayView(selectedColor: $selectedColor)
                    .tabItem {
                        Image(systemName: "location")
                    }
                    .tag(1)

                WeddingHomeView(selectedColor: $selectedColor)
                    .environmentObject(eventViewModel)
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(2)

                EventListView(selectedColor: $selectedColor)
                    .environmentObject(eventViewModel)
                    .tabItem {
                        Image(systemName: "calendar.badge.plus")
                    }
                    .tag(3)

                PeopleListView(selectedColor: $selectedColor)
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard")
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
