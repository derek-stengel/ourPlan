////
////  SpotifyAuthManager.swift
////  ourPlan
////
////  Created by Derek Stengel on 8/26/24.
////
//
//import Foundation
//import SpotifyiOS
//import Combine
//
//class SpotifyAuthManager: NSObject, ObservableObject {
//    static let shared = SpotifyAuthManager()
//
//    private let clientID = "504f8dd8a899460b8aefaa2e21cb4aef"
//    private let redirectURI = URL(string: "ourplan://callback")!
//    
//    @Published var accessToken: String?
//    @Published var lastError: Error?
//    private var refreshToken: String?
//    private var cancellables = Set<AnyCancellable>()
//    private let authUrl = "https://accounts.spotify.com/authorize"
//    
//    private var sessionManager: SPTSessionManager
//    private var tokenSwapURL: URL? = URL(string: "https://your-server.com/api/token") // Your backend endpoint to handle token exchange
//    private var tokenRefreshURL: URL? = URL(string: "https://your-server.com/api/refresh_token") // Your backend endpoint to handle token refresh
//
//    override init() {
//        let configuration = SPTConfiguration(clientID: clientID, redirectURL: redirectURI)
//        configuration.tokenSwapURL = tokenSwapURL
//        configuration.tokenRefreshURL = tokenRefreshURL
//        
//        self.sessionManager = SPTSessionManager(configuration: configuration, delegate: nil)
//        super.init()
//        self.sessionManager.delegate = self
//    }
//    
//    func authorize() {
//        let scopes = "playlist-modify-public playlist-modify-private"
//        let urlString = "\(authUrl)?client_id=\(clientID)&response_type=code&redirect_uri=\(redirectURI)&scope=\(scopes)&show_dialog=true"
//        
//        guard let url = URL(string: urlString) else { return }
//        UIApplication.shared.open(url)
//    }
//    
//    
//    func handleCallback(url: URL) {
//        sessionManager.application(UIApplication.shared, open: url, options: [:])
//    }
//
//    func refreshAccessToken() {
//        guard let refreshToken = refreshToken else { return }
//        
//        var request = URLRequest(url: tokenRefreshURL!)
//        request.httpMethod = "POST"
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        
//        let bodyParams = "grant_type=refresh_token&refresh_token=\(refreshToken)&client_id=\(clientID)"
//        request.httpBody = bodyParams.data(using: .utf8)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.lastError = error
//                }
//                return
//            }
//            
//            guard let data = data,
//                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                  let newAccessToken = json["access_token"] as? String else { return }
//            
//            DispatchQueue.main.async {
//                self.accessToken = newAccessToken
//            }
//        }.resume()
//    }
//}
//
//// MARK: - SPTSessionManagerDelegate
//extension SpotifyAuthManager: SPTSessionManagerDelegate {
//    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
//        DispatchQueue.main.async {
//            self.accessToken = session.accessToken
//            self.refreshToken = session.refreshToken
//        }
//    }
//    
//    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
//        DispatchQueue.main.async {
//            self.lastError = error
//        }
//    }
//    
//    func sessionManager(manager: SPTSessionManager, shouldRefreshAccessTokenFor session: SPTSession) -> Bool {
//        return true
//    }
//}
