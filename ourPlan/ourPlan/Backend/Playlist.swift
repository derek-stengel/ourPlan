//
//  Playlist.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/3/24.
//

import Foundation
import SpotifyiOS
import SwiftUI

struct Track {
    let id: String
    let name: String
    let artist: String
    let previewUrl: URL?
}

struct Playlist: Identifiable {
    let id: String
    let name: String
    let imageUrl: URL?
}
