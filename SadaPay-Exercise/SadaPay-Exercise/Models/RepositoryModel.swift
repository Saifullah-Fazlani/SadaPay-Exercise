//
//  TrendingListModel.swift
//  SadaPay-Exercise
//
//  Created by Saifullah on 19/06/2021.
//

import Foundation

// MARK: - Repository
struct Repository: Codable {
    var items: [Item]?

    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}

// MARK: - Item
struct Item: Codable {
    let name: String?
    let fullName: String?
    let owner: Owner?
    let itemDescription: String?
    let stargazersCount: Int?
    let language: String?
    
    var isExpandable = false

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case fullName = "full_name"
        case owner = "owner"
        case itemDescription = "description"
        case stargazersCount = "stargazers_count"
        case language = "language"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
