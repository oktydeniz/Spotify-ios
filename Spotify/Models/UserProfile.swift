//
//  UserProfile.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import Foundation


struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
   // let explicit_content: [String:Int]
    //let external_urls: [String: String]
    //let followers: [String: Codable?]
   // let href: String
    let id: String
    let product: String
  //  let uri: String
  //  let type: String
    let images: [APIImage]
}

