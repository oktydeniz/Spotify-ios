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
    
    public func getNewReleases(complation: @escaping((Result<NewReleasesResponse, Error>)) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET, complation: { req in
            let task = URLSession.shared.dataTask(with: req, completionHandler: { data, _ , error in
                guard let data = data, error == nil else {
                    complation(.failure(APIERROR.faileedToGetData))
                    return}
                
                do {
                    let json = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    complation(.success(json))
                    
                } catch {
                    complation(.failure(error))
                }
                
            })
            task.resume()
        })
        
    }
    
    public func getFeaturedPlaylists(complation: @escaping((Result<FeaturedPlaylistResponse, Error>))-> Void){
        createRequest(with: URL(string: Constant.baseAPIURL + "/browse/featured-playlists?limit=20"), type: .GET, complation:{ req in
            let task = URLSession.shared.dataTask(with: req, completionHandler: { response, _ , error in
                guard let data = response, error == nil else {return}
                do {
                    let json = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    print(json)
                    complation(.success(json))
                } catch {
                    complation(.failure(error))
                }
                
            })
            task.resume()
        })
        
    }
    
    public func getRecommendationsGenres(complation: @escaping((Result<RecommendedGenresResponse, Error>))-> Void){
        createRequest(with: URL(string: Constant.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET, complation:{ req in
            let task = URLSession.shared.dataTask(with: req, completionHandler: { response, _ , error in
                guard let data = response, error == nil else {return}
                do {
                    let json = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    print(json)
                    complation(.success(json))
                } catch {
                    complation(.failure(error))
                }
            })
            task.resume()
        })
    }
    
    public func getRecommendations(genres: Set<String>, complation: @escaping((Result<RecommendationsResponse, Error>))-> Void){
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constant.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"), type: .GET, complation:{ req in
            let task = URLSession.shared.dataTask(with: req, completionHandler: { response, _ , error in
                guard let data = response, error == nil else {return}
                do {
                    let json = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    print(json)
                    complation(.success(json))
                } catch {
                    complation(.failure(error))
                }
            })
            task.resume()
        })
    }
    
    
    public func getAlbumsDetails(for album:Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/albums/\(album.id)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let response = data, error == nil else {
                    completion(.failure(APIERROR.faileedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(AlbumDetailsResponse.self, from: response)
                    completion(.success(json))
                } catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getPlaylistDetails(for playlist:PlayList, completion: @escaping (Result<PlaylistDetailResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/playlists/\(playlist.id)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let response = data, error == nil else {
                    completion(.failure(APIERROR.faileedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(PlaylistDetailResponse.self, from: response)
                    completion(.success(json))
                } catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Category
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        createRequest(with:  URL(string: Constant.baseAPIURL + "/browse/categories?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let response = data, error == nil else {
                    completion(.failure(APIERROR.faileedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(AllCategoryResponse.self, from: response)
                    completion(.success(json.categories.items))
                } catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylist(category: Category ,completion: @escaping (Result<[PlayList], Error>) -> Void) {
        createRequest(with:  URL(string: Constant.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let response = data, error == nil else {
                    completion(.failure(APIERROR.faileedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(CategoryPlaylistResponse.self, from: response)
                    let pList = json.playlists.items
                    completion(.success(pList))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
}
