//
//  AllCategoryResponse.swift
//  Spotify
//
//  Created by oktay on 15.07.2023.
//

import Foundation



struct AllCategoryResponse : Codable {
    let categories: Categories
   
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}
