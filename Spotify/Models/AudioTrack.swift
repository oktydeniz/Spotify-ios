//
//  AudioTrack.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import Foundation


struct AudioTrack: Codable {
    let album: Album?
    let artists: [Artists]
    let available_markets: [String]
    let id: String
    let duration_ms: Int
    let disc_number: Int
    let explicit: Bool
    let name:String
    let external_urls: [String: String]
    let preview_url: String?
}
