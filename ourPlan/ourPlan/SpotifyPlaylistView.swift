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

//struct SpotifyPlaylistView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpotifyPlaylistView()
//            .environmentObject(SpotifyAuthManager.shared)
//    }
//}


//struct SpotifyPlaylistView: View {
//    @EnvironmentObject var authManager: SpotifyAuthManager
//    @State private var userPlaylists: [Playlist] = []
//    @State private var playlistName: String = ""
//    @State private var showCreatePlaylistView = false
//    @State private var showError = false
//    @State var selectedColor: UIColor
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
//                    VStack {
//                        List(userPlaylists, id: \.id) { playlist in
//                            NavigationLink(destination: PlaylistDetailView(playlist: playlist).environmentObject(authManager)) {
//                                HStack {
//                                    Text(playlist.name)
//                                    Spacer()
//                                    if let imageUrl = playlist.imageUrl {
//                                        AsyncImage(url: imageUrl) { image in
//                                            image.resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(width: 50, height: 50)
//                                                .cornerRadius(5)
//                                        } placeholder: {
//                                            ProgressView()
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        .navigationTitle("Playlists")
//                        .refreshable {
//                            refreshSpotifyData()
//                        }
//                        .onAppear {
//                            refreshSpotifyData()
//                        }
//                        .padding()
//                        .foregroundColor(.black)
//                    }
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
//                        CreatePlaylistView(isPresented: $showCreatePlaylistView, selectedColor: $selectedColor)
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
//struct SpotifyPlaylistView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpotifyPlaylistView()
//            .environmentObject(SpotifyAuthManager.shared)
//    }
//}

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
//    @State private var showError = false
//    @State private var showCreatePlaylistView = false
//    @Environment(\.scenePhase) var scenePhase
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                List(userPlaylists, id: \.id) { playlist in
//                    NavigationLink(destination: PlaylistDetailView(playlist: playlist).environmentObject(authManager)) {
//                        HStack {
//                            Text(playlist.name)
//                            Spacer()
//                            if let imageUrl = playlist.imageUrl {
//                                AsyncImage(url: imageUrl) { image in
//                                    image.resizable()
//                                         .aspectRatio(contentMode: .fit)
//                                         .frame(width: 50, height: 50)
//                                         .cornerRadius(5)
//                                } placeholder: {
//                                    ProgressView()
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding()
//                .foregroundColor(.black)
//            }
//            .navigationTitle("Playlists")
//            .navigationBarItems(trailing: Button(action: {
//                showCreatePlaylistView.toggle()
//            }) {
//                Image(systemName: "plus")
//            })
//            .onAppear {
//                refreshSpotifyData()
//            }
//            .onChange(of: authManager.accessToken) { _ in
//                refreshSpotifyData()
//            }
//            .onChange(of: scenePhase) { newValue in
//                if newValue == .active {
//                    refreshSpotifyData()
//                }
//            }
//            .alert(isPresented: $showError) {
//                Alert(title: Text("Error"), message: Text(authManager.lastError?.localizedDescription ?? "Unknown error"))
//            }
//            .sheet(isPresented: $showCreatePlaylistView) {
//                CreatePlaylistView(isPresented: $showCreatePlaylistView)
//                    .environmentObject(authManager)
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

//import SwiftUI
//import SpotifyiOS
//
//struct SpotifyPlaylistView: View {
//    @EnvironmentObject var authManager: SpotifyAuthManager
//    @State private var userPlaylists: [Playlist] = []
//    @State private var playlistName: String = ""
//    @State private var isCreatingPlaylist = false
//    @State private var showError = false
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
//                    VStack {
//                        TextField("Enter Playlist Name", text: $playlistName)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding()
//                        
//                        Button("Create Playlist") {
//                            createPlaylist(name: playlistName)
//                        }
//                        .padding()
//                        .disabled(isCreatingPlaylist)
//                        
//                        List(userPlaylists, id: \.id) { playlist in
//                            NavigationLink(destination: PlaylistDetailView(playlist: playlist).environmentObject(authManager)) {
//                                HStack {
//                                    Text(playlist.name)
//                                    Spacer()
//                                    if let imageUrl = playlist.imageUrl {
//                                        AsyncImage(url: imageUrl) { image in
//                                            image.resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(width: 50, height: 50)
//                                                .cornerRadius(5)
//                                        } placeholder: {
//                                            ProgressView()
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        .navigationTitle("Playlists")
//                        .refreshable {
//                            refreshSpotifyData()
//                        }
//                        .onAppear {
//                            refreshSpotifyData()
//                        }
//                        .padding()
//                        .foregroundColor(.black)
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
//                    .padding()
//                }
//            }
//        }
//    }
//    
//    func createPlaylist(name: String) {
//        guard let token = authManager.accessToken else { return }
//        
//        isCreatingPlaylist = true
//        
//        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body = ["name": name, "public": true] as [String: Any]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            isCreatingPlaylist = false
//            if let error = error {
//                authManager.lastError = error
//                showError = true
//                return
//            }
//            if let data = data {
//                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//                    print("Playlist created: \(json)")
//                    DispatchQueue.main.async {
//                        refreshSpotifyData()
//                    }
//                }
//            }
//        }.resume()
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
