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
        case DELETE
        case PUT
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
    
    // MARK: - Search
    
    public func search(with query: String, competion: @escaping (Result<[SearchResult], Error>) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" )"), type: .GET) { request in
            print(request.url?.absoluteString ?? "")
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let response = data, error == nil else {
                    competion(.failure(APIERROR.faileedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(SearchResultResponse.self, from: response)
                    var searchResult: [SearchResult] = []
                    searchResult.append(contentsOf: json.tracks.items.compactMap({
                        SearchResult.track(model: $0)
                    }))
                    searchResult.append(contentsOf: json.playlists.items.compactMap({
                        SearchResult.playlist(model: $0)
                    }))
                    searchResult.append(contentsOf: json.albums.items.compactMap({
                        SearchResult.album(model: $0)
                    }))
                    searchResult.append(contentsOf: json.artists.items.compactMap({
                        SearchResult.artist(model: $0)
                    }))
                    competion(.success(searchResult))
                } catch {
                    competion(.failure(error))
                }
            }
            task.resume()
        }
    }
    // MARK: - Playlist
    
    public func getCurrentUserPlaylist(completion: @escaping (Result<[PlayList], Error>) -> Void){
        createRequest(with: URL(string: Constant.baseAPIURL + "/me/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let response = data, error == nil else {
                    completion(.failure(APIERROR.faileedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: response)
                    completion(.success(json.items))
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func createPlaylist(with name:String, completion: @escaping (Bool) -> Void){
        getCurrentUserProfile(complation: { [weak self] result in
            switch result {
            case.success(let profile):
                let urlString = Constant.baseAPIURL + "/users/\(profile.id)/playlists"
                self?.createRequest(with: URL(string: urlString), type: .POST) { baseRequest in
                    var request = baseRequest
                    let json = ["name": name]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    let task = URLSession.shared.dataTask(with: request) { data , _ , error in
                        guard let response = data, error == nil else { completion(false); return }
                        do {
                            let json = try JSONSerialization.jsonObject(with: response, options: .allowFragments)
                            if let response = json as? [String: Any], response["id"] as? String != nil {
                                completion(true)
                                print("Created")
                            } else {
                                completion(false)
                                print("Failed to get id")
                            }
                        } catch {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                    task.resume()
                }
            case .failure(let error): print(error.localizedDescription)
            }
        })
    }
    
    public func addTrackToPlaylist(track: AudioTrack, playlist:PlayList, completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/playlists/\(playlist.id)/tracks"), type: .POST) { baseRequest in
            var request = baseRequest
            let json = ["uris":["spotify:track:\(track.id)"]]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else { completion(false); return}
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }catch {
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    public func removeTrackFromPlaylist(track: AudioTrack, playlist:PlayList, completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/playlists/\(playlist.id)/tracks"), type: .DELETE) { baseRequest in
            var request = baseRequest
            let json: [String: Any] = [
                    "tracks": [
                    "uri": "spotify:track:\(track.id)"
                    ]
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else { completion(false); return}
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }catch {
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Album

    public func getCurrentUserAlbum(completion: @escaping (Result<[Album], Error>) -> Void){
        createRequest(with: URL(string: Constant.baseAPIURL + "/me/albums"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let response = data, error == nil else {
                    completion(.failure(APIERROR.faileedToGetData))
                    return
                }
                do {
                    let json = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: response)
                    completion(.success(json.items.compactMap( {$0.album})))
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func saveAlbum(album: Album, completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: Constant.baseAPIURL + "/me/albums?ids=\(album.id)"), type: .PUT) { _request in
            var request = _request
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _response, error in
                guard let code = (_response as? HTTPURLResponse)?.statusCode, error == nil else {
                    completion(false)
                    return
                }
                completion(code == 200)
            }
            task.resume()
        }
    }
    
}
