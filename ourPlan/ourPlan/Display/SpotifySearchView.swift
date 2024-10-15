//
//  SpotifySearchView.swift
//  ourPlan
//
//  Created by Derek Stengel on 10/14/24.
//

import SwiftUI
import SpotifyiOS

struct SpotifySearchView: View {
    @EnvironmentObject var authManager: SpotifyAuthManager
    @State private var searchQuery: String = ""
    @State private var searchResults: [Track] = []
    @State private var selectedTrack: Track?
    @State private var selectedPlaylist: Playlist?
    @State private var showPlaylistSelection = false
    @State private var showError = false
    
    @Binding var selectedColor: UIColor
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search for songs...", text: $searchQuery, onCommit: {
                        searchTracks(query: searchQuery)
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    Button(action: {
                        searchTracks(query: searchQuery)
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    .padding(.trailing)
                }
                
                List(searchResults, id: \.id) { track in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(track.name)
                                .font(.system(size: 18, weight: .semibold))
                            Text(track.artist)
                                .font(.system(size: 14, weight: .light))
                        }
                        Spacer()
                        Button(action: {
                            selectedTrack = track
                            showPlaylistSelection = true
                        }) {
                            Text("Add to Playlist")
                                .font(.system(size: 12, weight: .medium))
                                .frame(width: 100, height: 8)
                                .padding()
                                .background(Color.green.gradient.opacity(0.8))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .navigationBarTitle("Search Tracks", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(selectedColor))
                Text("Back")
                    .foregroundColor(Color(selectedColor))
            })
            .sheet(isPresented: $showPlaylistSelection) {
                PlaylistSelectionView(selectedTrack: $selectedTrack, selectedPlaylist: $selectedPlaylist)
            }
        }
    }
    
    func searchTracks(query: String) {
        guard let accessToken = authManager.accessToken else { return }
        let url = URL(string: "https://api.spotify.com/v1/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&type=track")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error searching tracks: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let tracks = (json["tracks"] as? [String: Any])?["items"] as? [[String: Any]] {
                    let searchResults = tracks.compactMap { trackDict -> Track? in
                        guard let id = trackDict["id"] as? String,
                              let name = trackDict["name"] as? String,
                              let artist = trackDict["artists"] as? [[String: Any]],
                              let previewUrlString = trackDict["preview_url"] as? String,
                              let previewUrl = URL(string: previewUrlString) else { return nil }
                        let artistName = artist.first?["name"] as? String ?? "Unknown Artist"
                        return Track(id: id, name: name, artist: artistName, previewUrl: previewUrl)
                    }
                    DispatchQueue.main.async {
                        self.searchResults = searchResults
                    }
                }
            } catch {
                print("Error parsing search results: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func addTrackToPlaylist(track: Track, playlist: Playlist) {
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
                    showError = true
                }
            }.resume()
        }
    }
}

#Preview {
    SpotifySearchView(selectedColor: .constant(.green))
        .environmentObject(SpotifyAuthManager())
}
