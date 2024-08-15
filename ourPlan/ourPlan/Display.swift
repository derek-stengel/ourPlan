//
//  Display.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import Foundation
import SwiftUI

// Things to do:
// Change the calendar page to a honeymoon page (impliment flight data, hotels, locations, etc.)
// make the progress view just be on the home page
// instead of a calendar, make an 'events' tab. Allow the user to create an event, and have a set time and date (single or repeating) that the user will recieve a notification from the app about the certain event.
// make a button that allows the user to change the 'theme' (color scheme) in the Profile Settings view

// the tabs after this should be:
// Honeymoon, Map, Home, Events, People

enum Tab {
    case calendar
    case map
    case home
    case weddingProgress
    case peopleList
}

struct HomeContentView: View {
    @State private var selectedTab: Int = 2 // change this if you want the start-up tab to be different
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                CalendarDisplayView() // change this back to honeymoon, and look up documentation to impliment flight data, hotels, locations, etc.
                    .tabItem {
                        Image(systemName: "calendar")
                    }
                    .tag(0)
                
                MapDisplayView()
                    .tabItem {
                        Image(systemName: "mappin.and.ellipse")
                    }
                    .tag(1)
                
                WeddingHomeView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(2)
                
                WeddingProgressView()
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                    }
                    .tag(3)
                
                PeopleListView()
                    .tabItem {
                        Image(systemName: "person.badge.shield.checkmark.fill")
                    }
                    .tag(4)
            }
            .onAppear {
                setupTabBarAppearance()
            }
        }
    }
}

struct WeddingProgressView: View {
    var body: some View {
        VStack {
            Text("Progress View")
                .font(.largeTitle)
                .padding()
            Text("This will be a view where you can track progress of wedding goals.")
        }
    }
}

private func setupTabBarAppearance() {
    print("Setting up tab bar appearance") // Debug print statement
    
    let tabBarAppearance = UITabBarAppearance()
    
    // Background color setup
    tabBarAppearance.backgroundColor = UIColor.systemBackground
    
    // Set the appearance for selected and unselected tab items
    tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .systemIndigo
    tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
        .foregroundColor: UIColor.systemIndigo
    ]
    
    tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .gray
    tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
        .foregroundColor: UIColor.gray
    ]
    
    // Apply the appearance to both the standard and scrollEdge appearances
    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    UITabBar.appearance().standardAppearance = tabBarAppearance
}

struct HomeContentViewPreview: PreviewProvider {
    static var previews: some View {
        HomeContentView()
    }
}

