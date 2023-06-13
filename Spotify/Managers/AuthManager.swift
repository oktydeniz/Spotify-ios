//
//  AuthManager.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    private var refreshingToken = false
    private init() {}
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    public var singInURL: URL? {
        let str = "https://accounts.spotify.com/authorize?response_type=code&client_id=\(Constant.clientID)&scope=\(Constant.scopes)&redirect_uri=\(Constant.redirectUri)&show_dialog=true"
        return URL(string: str)
    }
    
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refresToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMin: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMin) >= expirationDate
    }
    
    public func exchangeCodeForToken(code:String, complation : @escaping (Bool)-> Void){
        guard let url = URL(string: Constant.tokenAPIURL) else {return}
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constant.redirectUri ),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        let basicToken = Constant.clientID + ":" + Constant.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            complation(false)
            return}
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request){ [weak self] data, _, error in
            guard let data = data, error == nil else {
                complation(false)
                return
            }
            do {
                let json = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: json)
                complation(true)
            }catch{
                print(error.localizedDescription)
                complation(false)
            }
        }
        task.resume()
        
    }
    
    private var onRefreshBlocks = [(String) -> Void]()
    
    // supplies valid token to be used with API calls
    public func withValidToken(complation: @escaping (String)->Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(complation)
            return
        }
        if shouldRefreshToken {
            refreshIfNeeded {[weak self] success in
                if let token = self?.accessToken, success {
                    complation(token)
                }
            }
        } else if let token = accessToken {
            complation(token)
        }
    }
    
    public func refreshIfNeeded(complation: @escaping (Bool) -> Void) {
        guard !refreshingToken else { return }
        guard shouldRefreshToken else {complation(true);return}
        guard let refresToken = self.refresToken else {return}
        guard let url = URL(string: Constant.tokenAPIURL) else {return}
        refreshingToken = true;
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refresToken),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        let basicToken = Constant.clientID + ":" + Constant.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            complation(false)
            return}
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request){ [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                complation(false)
                return
            }
            do {
                let json = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach{ $0(json.access_token)}
                self?.cacheToken(result: json)
                complation(true)
            }catch{
                print(error.localizedDescription)
                complation(false)
            }
        }
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
}
