//
//  APICaller.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init (){}
    
    enum APIERROR: Error {
        case faileedToGetData
    }
    
    public func getCurrentUserProfile(complation:@escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/me"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data, error == nil else {
                    complation(.failure(APIERROR.faileedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(result)
                    complation(.success(result))
                } catch {
                    complation(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, complation: @escaping (URLRequest) -> Void){
        AuthManager.shared.withValidToken { token in
            guard let _url = url else{
                return
            }
            var request = URLRequest(url:_url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            complation(request)
        }
    }
    
}
