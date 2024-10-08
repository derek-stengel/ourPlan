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
    @State var createPlaylistSheetHeight = PresentationDetent.height(CGFloat(235))
    
    var body: some View {
        VStack {
            if authManager.accessToken == nil {
                Button(action: {
                    authManager.authorize()
                }) {
                    Text("Log into your Spotify")
                        .font(.system(size: 22, weight: .semibold, design: .serif))
                        .padding()
                        .background(Color.green.gradient.opacity(0.8))
                        .foregroundColor(.black)
                        .frame(minHeight: 50)
                        .cornerRadius(10)
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
                        CreatePlaylistView(isPresented: $showCreatePlaylistView, selectedColor: $selectedColor, createPlaylistSheetHeight: $createPlaylistSheetHeight)
                            .environmentObject(authManager)
                            .presentationDetents([createPlaylistSheetHeight], selection: $createPlaylistSheetHeight)
                            .presentationDragIndicator(.hidden)
                    }
                }
            }
        }
    }
    
    func refreshSpotifyData() {
        authManager.checkAndRefreshTokenIfNeeded {
            fetchUserPlaylists()
        }
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
                    showError = true
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
}

struct SpotifyPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyPlaylistView(selectedColor: .constant(.blue))
            .environmentObject(SpotifyAuthManager())
    }
}
