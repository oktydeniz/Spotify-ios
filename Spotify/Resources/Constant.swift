//
//  Constant.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import Foundation


struct Constant {
    
    static let clientID = "<YOUR_CLIENT_ID>"
    static let clientSecret = "<YOUR_CLIENT_SECRET_KEY>"
    static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    static let redirectUri = "https://github.com/oktydeniz"
    static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
}
