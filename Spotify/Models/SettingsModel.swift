//
//  SettingsModel.swift
//  Spotify
//
//  Created by oktay on 13.06.2023.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}


struct Option {
    let title: String
    let handle: () -> Void
}
