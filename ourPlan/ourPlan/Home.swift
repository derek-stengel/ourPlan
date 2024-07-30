//
//  Home.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/28/24.
//

import Foundation
import SwiftUI

struct HomeContentView: View {
    var body: some View {
        TabView {
            CalendarDisplayView()
                .tabItem {
                    Image(systemName: "calendar")
                }
            MapView()
                .tabItem {
                    Image(systemName: "mappin.and.ellipse")
                }
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            WeddingProgressView()
                .tabItem {
                    Image(systemName: "pencil")
                }
            PeopleList()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                }
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
        VStack {
            Text("Map View")
                .font(.largeTitle)
                .padding()
            Text("This is the map view where you will be able to see venue and catering info.")
        }
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

struct HomeContentViewPreview: PreviewProvider {
    static var previews: some View {
        HomeContentView()
    }
}
