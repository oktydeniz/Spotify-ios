//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by oktay on 15.07.2023.
//

import Foundation


struct SearchResultResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResonse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
}

struct SearchArtistsResonse: Codable {
    let items: [Artists]
}

struct SearchPlaylistsResponse: Codable {
    let items: [PlayList]
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}
