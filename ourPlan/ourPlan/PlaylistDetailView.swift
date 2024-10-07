//
//  PlaylistDetailView.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/3/24.
//

// note for this file. I removed the audio functionality while i work on the 3rd party rights, so i can push what i have to the app store, and ill publish this in a later update.

import SwiftUI
import AVFoundation
import SpotifyiOS

struct PlaylistDetailView: View {
    let playlist: Playlist
    @EnvironmentObject var authManager: SpotifyAuthManager
    @State private var tracks: [Track] = []
    //    @State private var isPlaying = false
    @State private var currentTrack: Track?
    //    @State private var audioPlayer: AVPlayer?
    
    var body: some View {
        VStack {
            if tracks.isEmpty {
                Text("Build your dream playlist on the Spotify app. Playlist building in-app coming soon.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(tracks, id: \.id) { track in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(track.name)
                                .font(.headline)
                            Text(track.artist)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        //                        Spacer()
                        //                        Button(action: {
                        //                            playPreview(for: track)
                        //                        }) {
                        //                            Image(systemName: currentTrack?.id == track.id && isPlaying ? "pause.circle" : "play.circle")
                        //                                .font(.title)
                        //                        }
                    }
                }
                .navigationTitle(playlist.name)
            }
        }
        .onAppear {
            fetchTracks()
        }
        //        .onDisappear {
        //            audioPlayer?.pause()
        //        }
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
    
    //    func playPreview(for track: Track) {
    //        guard let previewUrl = track.previewUrl else { return }
    //
    //        if let currentTrack = currentTrack, currentTrack.id == track.id {
    //            // Pause if the same track is playing
    //            if isPlaying {
    //                audioPlayer?.pause()
    //            } else {
    //                audioPlayer?.play()
    //            }
    //            isPlaying.toggle()
    //        } else {
    //            currentTrack = track
    //            isPlaying = true
    //            audioPlayer = AVPlayer(url: previewUrl)
    //            audioPlayer?.play()
    //        }
    //    }
}

#Preview {
    PlaylistDetailView(playlist: Playlist(id: "1", name: "Despacito", imageUrl: nil))
        .environmentObject(SpotifyAuthManager())
}
