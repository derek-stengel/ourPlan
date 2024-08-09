//
//  Display.swift
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
                        Image(systemName: "square.and.pencil")
                    }
                    .tag(3)
                
                PeopleList()
                    .tabItem {
                        Image(systemName: "person.badge.shield.checkmark.fill")
                    }
                    .tag(4)
            }
            .onAppear {
                setupTabBarAppearance()
            }
//            .onChange(of: selectedTab) { newValue in
//                updateTabBarAppearance(for: newValue)
            }
        }
    }
    
    struct HomeView: View {
        var body: some View {
            WeddingHomeView()
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

