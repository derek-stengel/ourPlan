//
//  SpotifyPlaylistView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/26/24.
//

import SwiftUI
import SpotifyiOS

struct SpotifyPlaylistView: View {
    @StateObject private var authManager = SpotifyAuthManager.shared
    @State private var playlistName: String = ""
    @State private var userPlaylists: [Playlist] = [] // State to hold user playlists
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
                }
//                Button("Connect to Spotify") {
//                    authManager.authorize()
//                }
            } else {
                TextField("Enter Playlist Name", text: $playlistName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Create Playlist") {
                    createPlaylist(name: playlistName)
                }
                .padding()
                
                List(userPlaylists, id: \.id) { playlist in
                    Text(playlist.name)
                }
                .navigationTitle("Playlist Management")
                .refreshable {
                    refreshSpotifyData() // Called when the user pulls down to refresh
                }
                .onAppear {
                    refreshSpotifyData() // Load data when the view appears
                }
            }
        }
        .onChange(of: authManager.accessToken) { _ in
                // Refresh data when the access token is updated
                refreshSpotifyData()
        }
        .padding()
        
        .onChange(of: scenePhase) { oldValue, newValue in
            switch newValue {
            case .background:
                break
            case .inactive:
                break
            case .active:
                refreshSpotifyData()
            @unknown default:
                break
            }
        }
    }
    
    func createPlaylist(name: String) {
        guard let token = authManager.accessToken else { return }
        
        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["name": name, "public": true] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Playlist created: \(json)")
                    // Optionally, refresh playlists list after creating a new playlist
                    DispatchQueue.main.async {
                        refreshSpotifyData()
                    }
                }
            }
        }.resume()
    }

    func refreshSpotifyData() {
        guard let token = authManager.accessToken else { return }
        
        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    let playlists = items.compactMap { item -> Playlist? in
                        guard let id = item["id"] as? String,
                              let name = item["name"] as? String else { return nil }
                        return Playlist(id: id, name: name)
                    }
                    
                    DispatchQueue.main.async {
                        self.userPlaylists = playlists
                    }
                }
            }
        }.resume()
    }
}

struct Playlist {
    let id: String
    let name: String
}

struct SpotifyPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyPlaylistView()
    }
}
