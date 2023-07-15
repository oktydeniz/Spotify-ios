//
//  SearchResult.swift
//  Spotify
//
//  Created by oktay on 15.07.2023.
//

import Foundation


enum SearchResult {
    case artist(model: Artists)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: PlayList)
}

