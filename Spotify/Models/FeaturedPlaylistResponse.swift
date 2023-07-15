//
//  FeaturedPlaylistResponse.swift
//  Spotify
//
//  Created by oktay on 19.06.2023.
//

import Foundation


struct FeaturedPlaylistResponse: Codable {
    let playlists: PlayListResponse
}


struct CategoryPlaylistResponse: Codable {
    let playlists: PlayListResponse
}

struct PlayListResponse: Codable {
    let items: [PlayList]
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
    
}
