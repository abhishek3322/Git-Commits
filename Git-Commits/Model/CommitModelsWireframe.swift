//
//  CommitModelsWireframe.swift
//  Git-Commits
//
//  Created by Abhishek Tyagi on 11/7/20.
//

import Foundation

struct Commit: Decodable, Identifiable {
    var id: String
    var details: CommitDetails
    
    private enum CodingKeys: String, CodingKey {
        case id = "sha"
        case details = "commit"
    }
    
    var hash: String {
        return String(id.prefix(7))
    }
}

struct CommitDetails: Decodable {
    var author: Author
    var committer: Author
    var message: String
}

struct Author: Decodable {
    var name: String
    var email: String
    var updatedOn: Date
    
    private enum CodingKeys: String, CodingKey {
        case updatedOn = "date"
        case name, email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)

        let dateString = try container.decode(String.self, forKey: .updatedOn)
        let formatter = DateFormatter.iso8601Full
        if let date = formatter.date(from: dateString) {
            updatedOn = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .updatedOn,
                  in: container,
                  debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}
