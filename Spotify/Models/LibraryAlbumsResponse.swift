//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by oktay on 30.07.2023.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}


struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
