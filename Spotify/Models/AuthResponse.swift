//
//  AuthResponse.swift
//  Spotify
//
//  Created by oktay on 11.06.2023.
//

import Foundation



struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}

