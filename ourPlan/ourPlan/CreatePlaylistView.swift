//
//  CreatePlaylistView.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/7/24.
//

import SwiftUI
import SpotifyiOS

struct CreatePlaylistView: View {
    @EnvironmentObject var authManager: SpotifyAuthManager
    @Binding var isPresented: Bool
    @State private var playlistName: String = ""
    @State private var isCreatingPlaylist = false
    @State private var showError = false
    @Binding private var selectedColor: UIColor
    @Binding var createPlaylistSheetHeight: PresentationDetent
    
    init(isPresented: Binding<Bool>, selectedColor: Binding<UIColor>, createPlaylistSheetHeight: Binding<PresentationDetent>) {
            _isPresented = isPresented
            _selectedColor = selectedColor
            _createPlaylistSheetHeight = createPlaylistSheetHeight
        }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Enter Playlist Name", text: $playlistName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top)
                
                    .padding(10)
                
                Button(action: {
                    createPlaylist(name: playlistName)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(selectedColor))
                            .opacity(0.8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            
                        Text("Create Playlist")
                            .padding()
                            .foregroundColor(playlistName.isEmpty || isCreatingPlaylist ? Color.gray : Color.black)
                    }
                }
                .disabled(isCreatingPlaylist || playlistName.isEmpty)
                .padding(.horizontal)
                
                Spacer() // This pushes the content to the top
            }
            .navigationTitle("New Playlist")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(authManager.lastError?.localizedDescription ?? "Unknown error"))
            }
        }
    }
    
    func createPlaylist(name: String) {
        guard let token = authManager.accessToken else { return }
        
        isCreatingPlaylist = true
        
        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["name": name, "public": true] as [String: Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            isCreatingPlaylist = false
            if let error = error {
                authManager.lastError = error
                showError = true
                return
            }
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Playlist created: \(json)")
                    DispatchQueue.main.async {
                        isPresented = false
                    }
                }
            }
        }.resume()
    }
}

struct CreatePlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        
        CreatePlaylistView(
            isPresented: .constant(true), // Binding for showing or dismissing the view
            selectedColor: .constant(UIColor.systemCyan),
            createPlaylistSheetHeight: .constant(PresentationDetent.height(300)) // Provide a default value here
        )
        .environmentObject(SpotifyAuthManager()) // Provide an environment object if needed
    }
}



//
//import SwiftUI
//import SpotifyiOS
//
//struct CreatePlaylistView: View {
//    @EnvironmentObject var authManager: SpotifyAuthManager
//    @Binding var isPresented: Bool
//    @State private var playlistName: String = ""
//    @State private var isCreatingPlaylist = false
//    @State private var showError = false
//    @Binding private var selectedColor: UIColor
//    
//    init(isPresented: Binding<Bool>, selectedColor: Binding<UIColor>) {
//            _isPresented = isPresented
//            _selectedColor = selectedColor
//        }
//    
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading) {
//                TextField("Enter Playlist Name", text: $playlistName)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal)
//                    .padding(.top)
//                
//                Button(action: {
//                    createPlaylist(name: playlistName)
//                }) {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(selectedColor))
//                            .opacity(0.8)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 50)
//                            
//                        Text("Create Playlist")
//                            .padding()
//                            .foregroundColor(playlistName.isEmpty || isCreatingPlaylist ? Color.gray : Color.black)
//                    }
//                }
//                .disabled(isCreatingPlaylist || playlistName.isEmpty)
//                .padding(.horizontal)
//                
//                Spacer() // This pushes the content to the top
//            }
//            .navigationTitle("New Playlist")
//            .navigationBarItems(trailing: Button("Cancel") {
//                isPresented = false
//            })
//            .alert(isPresented: $showError) {
//                Alert(title: Text("Error"), message: Text(authManager.lastError?.localizedDescription ?? "Unknown error"))
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
//                        isPresented = false
//                    }
//                }
//            }
//        }.resume()
//    }
//}
