//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by oktay on 19.06.2023.
//

import Foundation


struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}

