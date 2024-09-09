//
//  Main.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import Foundation
import SwiftUI
import SpotifyiOS

// Things to do:
// Persistance is done on home, events, and the playlists for spotify. make sure you handle the individual songs persistance too. Map doesnt need it.
// Persistance is needed on PeopleList, and after you finish Spotify implimentation.
// fix the button on peopleListView that takes the user to iMessages: the contact doesnt get taken the first time, you have to deselected a contact, then reselect one, then it will grab ALL the selected contacts
//  !! blue dot on map showing current location ?
// app tour screens? If possible in time.
// the editEvent view that comes from EventInfoList does not send data back, so you cant update an event and have that data after closing the sheet

// TALK TO INSTRUCTOR: spotifylistview nav header moving, weddinghomeview eventdetailview not passing data back

// fix the import contacts button being present even though the contacts are imported
// when creating an event, allow the users to create / use filters to sort events by (like a color scheme)
// add search bar at the top of the syncContacts top allow people to search for specific people
// allow a filter in peopleListView for last name, first name, and job type
// when choosing a job on addPeopleView, make it a drop down where people have default list to choose from, but could also add their own

enum Tab {
    case honeymoon
    case map
    case home
    case events
    case peopleList
}

struct HomeContentView: View {
    @State private var selectedTab: Int = 2
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

                MapDisplayView()
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

                EventListView()
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
        // Create a binding for selectedColor with a default color
        HomeContentView(selectedColor: .constant(UIColor.systemCyan))
            .environmentObject(EventViewModel())
            .environmentObject(SpotifyAuthManager.shared)
    }
}


//
//import Foundation
//import SwiftUI
//import SpotifyiOS
//
//// Things to do:
//// make the progress view just be on the home page (maybe display upcoming events within a certain range / listed by date?)
//// create a button on PeopleListView that moves the user to the messages app, with a chat created and filled in with contact info from selected persons.
////  !! blue dot on map showing current location
//// app tour screens? If possible in time.
//
//enum Tab {
//    case honeymoon
//    case map
//    case home
//    case events
//    case peopleList
//}
//
//struct HomeContentView: View {
//    @State private var selectedTab: Int = 2
//    @Binding var selectedColor: UIColor
//    
//    var body: some View {
//        ZStack {
//            TabView(selection: $selectedTab) {
//                SpotifyPlaylistView()
//                    .tabItem {
//                        Image(systemName: "music.note.list")
//                    }
//                    .tag(0)
//
//                MapDisplayView()
//                    .tabItem {
//                        Image(systemName: "location")
//                    }
//                    .tag(1)
//
//                WeddingHomeView(selectedColor: $selectedColor)
//                    .tabItem {
//                        Image(systemName: "house")
//                    }
//                    .tag(2)
//
//                EventListView()
//                    .tabItem {
//                        Image(systemName: "text.book.closed")
//                    }
//                    .tag(3)
//
//                PeopleListView()
//                    .tabItem {
//                        Image(systemName: "person.badge.shield.checkmark.fill")
//                    }
//                    .tag(4)
//            }
//            .tint(Color.init(uiColor: selectedColor))
//        }
//    }
//}
//
//struct HomeContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Create a binding for selectedColor with a default color
//        HomeContentView(selectedColor: .constant(UIColor.systemCyan))
//    }
//}
//
