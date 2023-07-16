//
//  Artists.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import Foundation

struct Artists: Codable {
    
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
