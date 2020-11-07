//
//  CommitModelsWireframe.swift
//  Git-Commits
//
//  Created by Abhishek Tyagi on 11/7/20.
//

import Foundation

struct Commit: Decodable {
    var id: String
    var author: Author
    var committer: Committer
    var details: CommitDetails
    
    private enum CodingKeys: String, CodingKey {
        case id = "sha"
        case details = "commit"
        case committer, author
    }
}

struct CommitDetails: Decodable {
    var author: Author
    var committer: Committer
    var message: String
}

struct Author: Decodable {
    var name: String?
    var email: String?
    var date: String?
    var imageUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case imageUrl = "avatar_url"
        case name, email, date
    }
}

struct Committer: Decodable {
    var name: String?
    var email: String?
    var date: String?
    var imageUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case imageUrl = "avatar_url"
        case name, email, date
    }
}
