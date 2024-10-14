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
    @State private var searchQuery: String = ""
    @State private var searchResults: [Track] = []
    @State private var selectedPlaylist: Playlist?
    @State private var playlistName: String = ""
    @State var showCreatePlaylistView = false
    @State var showSearchView = false
    @State private var showError = false
    @Binding var selectedColor: UIColor
    
    @Environment(\.scenePhase) var scenePhase
    @State var createPlaylistSheetHeight = PresentationDetent.height(CGFloat(235))
    
    init(userPlaylists: [Playlist], selectedColor: Binding<UIColor>) {
        _userPlaylists = State(initialValue: userPlaylists)
        _selectedColor = selectedColor
    }
    
    var body: some View {
        VStack {
            if authManager.accessToken == nil {
                Button(action: {
                    authManager.authorize()
                }) {
                    VStack {
                        Text("Log into your Spotify")
                            .font(.system(size: 22, weight: .medium))
                            .padding()
                            .background(Color.green.gradient.opacity(0.8))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(1)
                        
                        Text("More music streaming options coming soon.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(UIColor.white))
                            .cornerRadius(10)
                    }
                }
            } else {
                NavigationView {
                    List {
                        ForEach(userPlaylists, id: \.id) { playlist in
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
                            .onTapGesture {
                                selectedPlaylist = playlist
                            }
                        }
                        
                        Section {
                            HStack {
                                Spacer()
                                Text("Changes made directly reflect on Spotify within a few minutes.")
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                        .listRowBackground(Color(UIColor.secondarySystemBackground))
                    }
                    .refreshable {
                        refreshSpotifyData()
                    }
                    .onAppear {
                        refreshSpotifyData()
                    }
                    .foregroundColor(.black)
                    .navigationTitle("Your Playlists")
                    .navigationBarItems(
                        leading: Button(action: {
                            showCreatePlaylistView.toggle()
                        }) {
                            VStack(alignment: .center, spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.green))
                                        .opacity(0.7)
                                        .frame(width: 120)
                                        .frame(height: 35)
                                    Text("New Playlist")
                                        .padding(.horizontal)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                            }
                        },
                        trailing: Button(action: {
                            showSearchView = true
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                    )
                    .sheet(isPresented: $showSearchView) {
                        SpotifySearchView()
                    }
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

struct SpotifyPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        let mockPlaylists = [
            Playlist(id: "1", name: "Chill Vibes", imageUrl: URL(string: "https://via.placeholder.com/50")),
            Playlist(id: "2", name: "Workout Hits", imageUrl: URL(string: "https://via.placeholder.com/50"))
        ]
        
        return SpotifyPlaylistView(userPlaylists: mockPlaylists, selectedColor: .constant(UIColor.green))
            .environmentObject(SpotifyAuthManager())
    }
}

// OLD CODE, USE ONLY IF CURRENT CODE CAUSES ISSUES

////
////  SpotifyPlaylistView.swift
////  ourPlan
////
////  Created by Derek Stengel on 8/26/24.
////
//
//import SwiftUI
//import SpotifyiOS
//
//struct SpotifyPlaylistView: View {
//    @EnvironmentObject var authManager: SpotifyAuthManager
//    @State private var userPlaylists: [Playlist] = []
//    @State private var searchQuery: String = ""
//    @State private var searchResults: [Track] = []
//    @State private var selectedPlaylist: Playlist?
//    @State private var playlistName: String = ""
//    @State var showCreatePlaylistView = false
//    @State var showSearchView = false
//    @State private var showError = false
//    @Binding var selectedColor: UIColor
//
//    @Environment(\.scenePhase) var scenePhase
//    @State var createPlaylistSheetHeight = PresentationDetent.height(CGFloat(235))
//
//    init(userPlaylists: [Playlist], selectedColor: Binding<UIColor>) {
//        _userPlaylists = State(initialValue: userPlaylists)
//        _selectedColor = selectedColor
//    }
//
//    var body: some View {
//        VStack {
//            if authManager.accessToken == nil {
//                Button(action: {
//                    authManager.authorize()
//                }) {
//                    Text("Log into your Spotify")
//                        .font(.system(size: 22, weight: .medium))
//                        .padding()
//                        .background(Color.green.gradient.opacity(0.8))
//                        .foregroundColor(.black)
//                        .cornerRadius(10)
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
//                        .onTapGesture {
//                            selectedPlaylist = playlist
//                        }
//                    }
//                    .refreshable {
//                        refreshSpotifyData()
//                    }
//                    .onAppear {
//                        refreshSpotifyData()
//                    }
//                    .foregroundColor(.black)
//                    .navigationTitle("Your Playlists")
//                    .navigationBarItems(
//                        leading: Button(action: {
//                            showCreatePlaylistView.toggle()
//                        }) {
//                            VStack(alignment: .center, spacing: 12) {
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .fill(Color(.green))
//                                        .opacity(0.7)
//                                        .frame(width: 120)
//                                        .frame(height: 35)
//                                    Text("New Playlist")
//                                        .padding(.horizontal)
//                                        .fontWeight(.semibold)
//                                        .foregroundColor(.black)
//                                }
//                            }
//                        },
//                        trailing: Button(action: {
//                            showSearchView = true
//                        }) {
//                            Image(systemName: "magnifyingglass")
//                        }
//                    )
//                    .sheet(isPresented: $showSearchView) {
//                        SpotifySearchView()
//                        //                                .onDisappear {
//                        //                                    // viewmodel.searchImported = true look at peoplelistview line 120
//                        //                                }
//                    }
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
//                        CreatePlaylistView(isPresented: $showCreatePlaylistView, selectedColor: $selectedColor, createPlaylistSheetHeight: $createPlaylistSheetHeight)
//                            .environmentObject(authManager)
//                            .presentationDetents([createPlaylistSheetHeight], selection: $createPlaylistSheetHeight)
//                            .presentationDragIndicator(.hidden)
//                    }
//                } // comment this
//            } // and this
//        }
//    }
//
//    func refreshSpotifyData() {
//        authManager.checkAndRefreshTokenIfNeeded {
//            fetchUserPlaylists()
//        }
//    }
//
//    func fetchUserPlaylists() {
//        guard let accessToken = authManager.accessToken else { return }
//        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error fetching playlists: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    showError = true
//                    authManager.lastError = error
//                }
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let items = json["items"] as? [[String: Any]] {
//                    let playlists = items.compactMap { item -> Playlist? in
//                        guard let id = item["id"] as? String,
//                              let name = item["name"] as? String else { return nil }
//                        let imageUrl = (item["images"] as? [[String: Any]])?.first?["url"] as? String
//                        return Playlist(id: id, name: name, imageUrl: URL(string: imageUrl ?? ""))
//                    }
//
//                    DispatchQueue.main.async {
//                        userPlaylists = playlists
//                    }
//                }
//            } catch {
//                print("Error parsing JSON: \(error.localizedDescription)")
//            }
//        }.resume()
//    }
//
//    func searchTracks(query: String) {
//        guard let accessToken = authManager.accessToken else { return }
//        let url = URL(string: "https://api.spotify.com/v1/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&type=track")!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error searching tracks: \(error.localizedDescription)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let tracks = (json["tracks"] as? [String: Any])?["items"] as? [[String: Any]] {
//                    let searchResults = tracks.compactMap { trackDict -> Track? in
//                        guard let id = trackDict["id"] as? String,
//                              let name = trackDict["name"] as? String,
//                              let artist = trackDict["artists"] as? [[String: Any]],
//                              let previewUrlString = trackDict["preview_url"] as? String,
//                              let previewUrl = URL(string: previewUrlString) else { return nil }
//                        let artistName = artist.first?["name"] as? String ?? "Unknown Artist"
//                        return Track(id: id, name: name, artist: artistName, previewUrl: previewUrl)
//                    }
//                    DispatchQueue.main.async {
//                        self.searchResults = searchResults
//                    }
//                }
//            } catch {
//                print("Error parsing search results: \(error.localizedDescription)")
//            }
//        }.resume()
//    }
//
//    private func addTrackToPlaylist(track: Track, playlist: Playlist) {
//        authManager.checkAndRefreshTokenIfNeeded {
//            guard let accessToken = authManager.accessToken,
//                  let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlist.id)/tracks") else { return }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            let body: [String: Any] = ["uris": ["spotify:track:\(track.id)"]]
//            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("Error adding track to playlist: \(error.localizedDescription)")
//                    showError = true
//                }
//            }.resume()
//        }
//    }
//}
//
//struct SpotifyPlaylistView_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockPlaylists = [
//            Playlist(id: "1", name: "Chill Vibes", imageUrl: URL(string: "https://via.placeholder.com/50")),
//            Playlist(id: "2", name: "Workout Hits", imageUrl: URL(string: "https://via.placeholder.com/50")),
//            Playlist(id: "3", name: "Top 50", imageUrl: URL(string: "https://via.placeholder.com/50"))
//        ]
//
//        SpotifyPlaylistView(userPlaylists: mockPlaylists, selectedColor: .constant(.blue))
//            .environmentObject(SpotifyAuthManager())
//    }
//}
