//
//  Home.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import Foundation
import SwiftUI

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
            CalendarDisplayView()
                .tabItem {
                    Image(systemName: "calendar")
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    Image(systemName: "mappin.and.ellipse")
                }
                .tag(1)
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(2)
            
            WeddingProgressView()
                .tabItem {
                    Image(systemName: "pencil")
                }
                .tag(3)
            
            PeopleList()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                }
                .tag(4)
        }
        .onChange(of: selectedTab) { newValue in
                        updateTabBarAppearance(for: newValue)
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home Page")
                .font(.largeTitle)
                .padding()
            Text("This is the home view where data will display about current goal tracking progress and other 'home' items.")
        }
    }
}

struct MapView: View {
    var body: some View {
        MapDisplayView()
    }
}

struct PeopleList: View {
    var body: some View {
        PeopleListView()
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
    
    private func updateTabBarAppearance(for tabIndex: Int) {
            let tabBarAppearance = UITabBarAppearance()
            
            if tabIndex == 1 { // MapView tab index
                tabBarAppearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7) // Adjust transparency
            } else {
                tabBarAppearance.backgroundColor = UIColor.systemBackground // Full opacity
            }
            
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            UITabBar.appearance().standardAppearance = tabBarAppearance
        }
    }

struct HomeContentViewPreview: PreviewProvider {
    static var previews: some View {
        HomeContentView()
    }
}
