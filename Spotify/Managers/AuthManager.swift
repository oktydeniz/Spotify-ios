//
//  AuthManager.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    private init() {}
    
    var isSignedIn: Bool {
        return false
    }
    
    public var singInURL: URL? {
        let scopes = "user-read-private"
        let redirectUri = "<YOUR_REDIRECT_URI>"
        let str = "https://accounts.spotify.com/authorize?response_type=code&client_id=\(Constant.clientID)&scope=\(scopes)&redirect_uri=\(redirectUri)&show_dialog=true"
        return URL(string: str)
    }
    
    
    private var accessToken: String? {
        return nil
    }
    
    private var refresToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    public func exchangeCodeForToken(code:String, complation : @escaping (Bool)-> Void){
        
    }
    private func refreshAccessToken() {
        
    }
    
    private func cacheToken(){
        
    }
}
