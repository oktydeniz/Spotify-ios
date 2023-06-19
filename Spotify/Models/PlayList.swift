//
//  PlayList.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import Foundation

struct PlayList: Codable {
    
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
