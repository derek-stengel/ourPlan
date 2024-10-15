//
//  PlaylistSelectionView.swift
//  ourPlan
//
//  Created by Derek Stengel on 10/14/24.
//

import Foundation
import SwiftUI

struct PlaylistSelectionView: View {
    @Binding var selectedTrack: Track?
    @Binding var selectedPlaylist: Playlist?
    @State private var userPlaylists: [Playlist] = []
    @EnvironmentObject var authManager: SpotifyAuthManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            Text("Add to Playlist")
                .bold()
            
            List(userPlaylists, id: \.id) { playlist in
                Button(action: {
                    selectedPlaylist = playlist
                    addTrackToPlaylist()
                    dismiss()
                }) {
                    Text(playlist.name)
                        .font(.system(size: 20))
                }
            }
        }
        .onAppear(perform: fetchUserPlaylists)
    }
    
    func fetchUserPlaylists() {
        guard let accessToken = authManager.accessToken else { return }
        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching playlists: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    authManager.lastError = error
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    let playlists = items.compactMap { item -> Playlist? in
                        guard let id = item["id"] as? String,
                              let name = item["name"] as? String else { return nil }
                        let imageUrl = (item["images"] as? [[String: Any]])?.first?["url"] as? String
                        return Playlist(id: id, name: name, imageUrl: URL(string: imageUrl ?? ""))
                    }
                    
                    DispatchQueue.main.async {
                        userPlaylists = playlists
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func addTrackToPlaylist() {
        if let track = selectedTrack, let playlist = selectedPlaylist {
            authManager.checkAndRefreshTokenIfNeeded {
                guard let accessToken = authManager.accessToken,
                      let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlist.id)/tracks") else { return }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let body: [String: Any] = ["uris": ["spotify:track:\(track.id)"]]
                request.httpBody = try? JSONSerialization.data(withJSONObject: body)
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error adding track to playlist: \(error.localizedDescription)")
                    }
                }.resume()
            }
        }
    }
}
