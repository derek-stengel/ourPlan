//
//  SpotifyAuthManager.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/26/24.
//

import Foundation
import Combine
import UIKit
import SpotifyiOS

class SpotifyAuthManager: ObservableObject {
    static let shared = SpotifyAuthManager()  // Singleton instance

    @Published var accessToken: String?

    private let clientId = "504f8dd8a899460b8aefaa2e21cb4aef"
    private let clientSecret = "06cf8e3211cf4ddd9e53f81b898f1eb8"
    private let redirectUri = "ourplan://callback"
    private let tokenUrl = "https://accounts.spotify.com/api/token"
    private let authUrl = "https://accounts.spotify.com/authorize"

    func authorize() {
        let scopes = "playlist-modify-public playlist-modify-private"
        let urlString = "\(authUrl)?client_id=\(clientId)&response_type=code&redirect_uri=\(redirectUri)&scope=\(scopes)&show_dialog=true"
        
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }

    func handleCallback(url: URL) {
        guard let code = extractCode(from: url) else { return }
        exchangeCodeForToken(code: code)
    }

    private func extractCode(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }
        return queryItems.first(where: { $0.name == "code" })?.value
    }

    private func exchangeCodeForToken(code: String) {
        guard let url = URL(string: tokenUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = "grant_type=authorization_code&code=\(code)&redirect_uri=\(redirectUri)&client_id=\(clientId)&client_secret=\(clientSecret)"
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["access_token"] as? String {
                    DispatchQueue.main.async {
                        self.accessToken = token
                    }
                }
            }
        }.resume()
    }
}
