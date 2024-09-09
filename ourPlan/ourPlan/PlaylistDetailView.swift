    //
    //  PlaylistDetailView.swift
    //  ourPlan
    //
    //  Created by Derek Stengel on 9/3/24.
    //

    import SwiftUI
    import AVFoundation
    import SpotifyiOS

    struct PlaylistDetailView: View {
        let playlist: Playlist
        @EnvironmentObject var authManager: SpotifyAuthManager
        @State private var tracks: [Track] = []
        @State private var isPlaying = false
        @State private var currentTrack: Track?
        @State private var audioPlayer: AVPlayer?

        var body: some View {
            VStack {
                if tracks.isEmpty {
                    Text("No tracks available")
                } else {
                    List(tracks, id: \.id) { track in
                        HStack {
                            VStack(alignment: .leading) {
    //                            if let previewUrl = track.previewUrl {
    //                                AsyncImage(url: previewUrl) { image in
    //                                    image.resizable()
    //                                         .aspectRatio(contentMode: .fit)
    //                                         .frame(width: 50, height: 50)
    //                                         .cornerRadius(5)
    //                                }
                                Text(track.name)
                                    .font(.headline)
                                Text(track.artist)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: {
                                playPreview(for: track)
                            }) {
                                Image(systemName: currentTrack?.id == track.id && isPlaying ? "pause.circle" : "play.circle")
                                    .font(.title)
                            }
                        }
                    }
                    .navigationTitle(playlist.name)
                }
            }
            .onAppear {
                fetchTracks()
            }
            .onDisappear {
                audioPlayer?.pause()  // Stop playback when the view disappears
            }
        }

        func fetchTracks() {
            guard let token = authManager.accessToken else { return }
            
            let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlist.id)/tracks")!
            var request = URLRequest(url: url)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    authManager.lastError = error
                    return
                }
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let items = json["items"] as? [[String: Any]] {
                        DispatchQueue.main.async {
                            tracks = items.compactMap { item in
                                guard let track = item["track"] as? [String: Any] else { return nil }
                                return Track(id: track["id"] as! String,
                                             name: track["name"] as! String,
                                             artist: (track["artists"] as? [[String: Any]])?.first?["name"] as? String ?? "",
                                             previewUrl: URL(string: track["preview_url"] as? String ?? ""))
                            }
                        }
                    }
                }
            }.resume()
        }

        func playPreview(for track: Track) {
            guard let previewUrl = track.previewUrl else { return }

            if let currentTrack = currentTrack, currentTrack.id == track.id {
                // Pause if the same track is playing
                if isPlaying {
                    audioPlayer?.pause()
                } else {
                    audioPlayer?.play()
                }
                isPlaying.toggle()
            } else {
                // Play new track
                currentTrack = track
                isPlaying = true
                audioPlayer = AVPlayer(url: previewUrl)
                audioPlayer?.play()
            }
        }
    }






//import SwiftUI
//import SpotifyiOS
//import AVFoundation
//
//struct PlaylistDetailView: View {
//    var playlist: Playlist
//    @EnvironmentObject var authManager: SpotifyAuthManager
//    @State private var tracks: [Track] = []
//    @State private var player: AVPlayer?
//    
//    var body: some View {
//        VStack {
//            if tracks.isEmpty {
//                Text("Loading tracks...")
//            } else {
//                List(tracks) { track in
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(track.name)
//                                .font(.headline)
//                            Text(track.artistName)
//                                .font(.subheadline)
//                        }
//                        Spacer()
//                        if track.previewUrl != nil {
//                            Button("Play Preview") {
//                                playPreview(for: track)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .navigationTitle(playlist.name)
//        .onAppear {
//            fetchTracks(for: playlist.id) { fetchedTracks in
//                if let fetchedTracks = fetchedTracks {
//                    tracks = fetchedTracks
//                }
//            }
//        }
//    }
//    
//    func playPreview(for track: Track) {
//        guard let url = track.previewUrl else { return }
//        player = AVPlayer(url: url)
//        player?.play()
//    }
//    
//    func fetchTracks(for playlistId: String, completion: @escaping ([Track]?) -> Void) {
//        guard let token = authManager.accessToken else { return }
//        
//        let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlistId)/tracks")!
//        var request = URLRequest(url: url)
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error fetching tracks: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//            
//            if let data = data {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                    let items = json?["items"] as? [[String: Any]] ?? []
//                    
//                    let tracks: [Track] = items.compactMap { item in
//                        guard let trackInfo = item["track"] as? [String: Any] else { return nil }
//                        return Track(
//                            id: trackInfo["id"] as! String,
//                            name: trackInfo["name"] as! String,
//                            artistName: (trackInfo["artists"] as? [[String: Any]])?.first?["name"] as? String ?? "",
//                            albumName: (trackInfo["album"] as? [String: Any])?["name"] as? String ?? "",
//                            previewUrl: URL(string: trackInfo["preview_url"] as? String ?? "")
//                        )
//                    }
//                    DispatchQueue.main.async {
//                        completion(tracks)
//                    }
//                } catch {
//                    print("Error parsing tracks: \(error.localizedDescription)")
//                    completion(nil)
//                }
//            }
//        }.resume()
//    }
//}


