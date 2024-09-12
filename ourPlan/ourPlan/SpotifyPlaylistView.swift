//
//  SpotifyPlaylistView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/26/24.
//

import SwiftUI
import SpotifyiOS

struct SpotifyPlaylistView: View {
    @EnvironmentObject var authManager: SpotifyAuthManager
    @State private var userPlaylists: [Playlist] = []
    @State private var playlistName: String = ""
    @State var showCreatePlaylistView = false
    @State private var showError = false
    @Binding var selectedColor: UIColor
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            if authManager.accessToken == nil {
                Button(action: {
                    authManager.authorize()
                }) {
                    Image("SpotifyLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .rotatingGradientBorder()
                }
            } else {
                NavigationView {
                    List(userPlaylists, id: \.id) { playlist in
                        NavigationLink(destination: PlaylistDetailView(playlist: playlist).environmentObject(authManager)) {
                            HStack {
                                Text(playlist.name)
                                Spacer()
                                if let imageUrl = playlist.imageUrl {
                                    AsyncImage(url: imageUrl) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(5)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                        }
                    }
                    .refreshable {
                        refreshSpotifyData()
                    }
                    .onAppear {
                        refreshSpotifyData()
                    }
                    .foregroundColor(.black)
                    .navigationTitle("Playlists")
                    .navigationBarItems(trailing: Button(action: {
                        showCreatePlaylistView.toggle()
                    }) {
                        Image(systemName: "plus")
                    })
                    .onChange(of: authManager.accessToken) { _ in
                        refreshSpotifyData()
                    }
                    .onChange(of: scenePhase) { newValue in
                        if newValue == .active {
                            refreshSpotifyData()
                        }
                    }
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Error"), message: Text(authManager.lastError?.localizedDescription ?? "Unknown error"))
                    }
                    .sheet(isPresented: $showCreatePlaylistView) {
                        CreatePlaylistView(isPresented: $showCreatePlaylistView, selectedColor: $selectedColor)  // Pass the binding
                            .environmentObject(authManager)
                    }
                }
            }
        }
    }
    
    func refreshSpotifyData() {
        guard let token = authManager.accessToken else { return }
        
        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                authManager.lastError = error
                showError = true
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                // Token is expired, try to refresh it
                authManager.refreshAccessToken()
                return
            }
            
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    DispatchQueue.main.async {
                        userPlaylists = items.map { Playlist(id: $0["id"] as! String, name: $0["name"] as! String, imageUrl: URL(string: ($0["images"] as? [[String: Any]])?.first?["url"] as? String ?? "")) }
                    }
                }
            }
        }.resume()
    }
}
//
//import SwiftUI
//import SpotifyiOS
//
//struct SpotifyPlaylistView: View {
//    @EnvironmentObject var authManager: SpotifyAuthManager
//    @State private var userPlaylists: [Playlist] = []
//    @State private var playlistName: String = ""
//    @State var showCreatePlaylistView = false
//    @State private var showError = false
//    @Binding var selectedColor: UIColor
//    @Environment(\.scenePhase) var scenePhase
//    
//    var body: some View {
//        VStack {
//            if authManager.accessToken == nil {
//                Button(action: {
//                    authManager.authorize()
//                }) {
//                    Image("SpotifyLogo")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 100, height: 100)
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                        .rotatingGradientBorder()
//                }
//            } else {
//                NavigationView {
//                    List(userPlaylists, id: \.id) { playlist in
//                        NavigationLink(destination: PlaylistDetailView(playlist: playlist).environmentObject(authManager)) {
//                            HStack {
//                                Text(playlist.name)
//                                Spacer()
//                                if let imageUrl = playlist.imageUrl {
//                                    AsyncImage(url: imageUrl) { image in
//                                        image.resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 50, height: 50)
//                                            .cornerRadius(5)
//                                    } placeholder: {
//                                        ProgressView()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .refreshable {
//                        refreshSpotifyData()
//                    }
//                    .onAppear {
//                        refreshSpotifyData()
//                    }
//                    .foregroundColor(.black)
//                    .navigationTitle("Playlists")
//                    .navigationBarItems(trailing: Button(action: {
//                        showCreatePlaylistView.toggle()
//                    }) {
//                        Image(systemName: "plus")
//                    })
//                    .onChange(of: authManager.accessToken) { _ in
//                        refreshSpotifyData()
//                    }
//                    .onChange(of: scenePhase) { newValue in
//                        if newValue == .active {
//                            refreshSpotifyData()
//                        }
//                    }
//                    .alert(isPresented: $showError) {
//                        Alert(title: Text("Error"), message: Text(authManager.lastError?.localizedDescription ?? "Unknown error"))
//                    }
//                    .sheet(isPresented: $showCreatePlaylistView) {
//                        CreatePlaylistView(isPresented: $showCreatePlaylistView, selectedColor: $selectedColor)  // Pass the binding
//                            .environmentObject(authManager)
//                    }
//                }
//            }
//        }
//    }
//    
//    func refreshSpotifyData() {
//        guard let token = authManager.accessToken else { return }
//        
//        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
//        var request = URLRequest(url: url)
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                authManager.lastError = error
//                showError = true
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
//                // Token is expired, try to refresh it
//                authManager.refreshAccessToken()
//                return
//            }
//            
//            if let data = data {
//                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let items = json["items"] as? [[String: Any]] {
//                    DispatchQueue.main.async {
//                        userPlaylists = items.map { Playlist(id: $0["id"] as! String, name: $0["name"] as! String, imageUrl: URL(string: ($0["images"] as? [[String: Any]])?.first?["url"] as? String ?? "")) }
//                    }
//                }
//            }
//        }.resume()
//    }
//}
//
