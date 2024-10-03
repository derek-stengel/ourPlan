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
    static let shared = SpotifyAuthManager()
    
    @Published var accessToken: String? {
        didSet {
            UserDefaults.standard.set(accessToken, forKey: "accessToken")
        }
    }
    @Published var refreshToken: String? {
        didSet {
            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
        }
    }
    @Published var isLoading = false
    @Published var lastError: Error?
    
    private let clientId = "504f8dd8a899460b8aefaa2e21cb4aef"
    private let clientSecret = "06cf8e3211cf4ddd9e53f81b898f1eb8"
    private let redirectUri = "ourplan://callback"
    private let tokenUrl = "https://accounts.spotify.com/api/token"
    private let authUrl = "https://accounts.spotify.com/authorize"
    
    private var cancellables = Set<AnyCancellable>()
    
    struct TokenResponse: Decodable {
        let access_token: String
        let refresh_token: String?
        let expires_in: Int
    }
    
    private var expirationDate: Date? {
        didSet {
            UserDefaults.standard.set(expirationDate, forKey: "tokenExpirationDate")
        }
    }
    
    init() {
        accessToken = UserDefaults.standard.string(forKey: "accessToken")
        refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        expirationDate = UserDefaults.standard.object(forKey: "tokenExpirationDate") as? Date
    }
    
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
        
        isLoading = true
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: TokenResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.lastError = error
                    print("Error exchanging code for token: \(error.localizedDescription)")
                }
            }, receiveValue: { tokenResponse in
                self.accessToken = tokenResponse.access_token
                self.refreshToken = tokenResponse.refresh_token
                self.expirationDate = Date().addingTimeInterval(TimeInterval(tokenResponse.expires_in))
            })
            .store(in: &cancellables)
    }
    
    func refreshAccessToken(completion: @escaping () -> Void = {}) {
        guard let refreshToken = refreshToken else { return }
        guard let url = URL(string: tokenUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = "grant_type=refresh_token&refresh_token=\(refreshToken)&client_id=\(clientId)&client_secret=\(clientSecret)"
        request.httpBody = body.data(using: .utf8)
        
        isLoading = true
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: TokenResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                self.isLoading = false
                switch completionStatus {
                case .finished:
                    completion()
                case .failure(let error):
                    self.lastError = error
                    print("Error refreshing access token: \(error.localizedDescription)")
                }
            }, receiveValue: { tokenResponse in
                self.accessToken = tokenResponse.access_token
                self.expirationDate = Date().addingTimeInterval(TimeInterval(tokenResponse.expires_in))
            })
            .store(in: &cancellables)
    }
    
    func checkAndRefreshTokenIfNeeded(completion: @escaping () -> Void) {
        if let expirationDate = expirationDate, Date() > expirationDate {
            refreshAccessToken(completion: completion)
        } else {
            completion()
        }
    }
}
