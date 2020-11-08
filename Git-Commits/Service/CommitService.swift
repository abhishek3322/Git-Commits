//
//  CommitService.swift
//  Git-Commits
//
//  Created by Abhishek Tyagi on 11/7/20.
//

import Foundation
import Alamofire

class CommitService: ObservableObject {
    
    let gitUrl = "https://api.github.com/repos/"
    let sinceTime = "2020-01-01T0:00:00Z"

    @Published var commits: [Commit] = []
    @Published var isFetchingCommits: Bool = false
    
    func fetchLatest(author: String, repo: String, completion: @escaping (Bool) -> Void) {
        isFetchingCommits = true
        let request = AF.request("\(gitUrl)\(author)/\(repo)/commits?since=\(sinceTime)")
        request.response { (response) in
            self.isFetchingCommits = false
            guard let data = response.data else {
                completion(false)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            
            do {
                let commits = try decoder.decode([Commit].self, from: data)
                self.commits = commits
                completion(true)
                
            }catch {
                completion(false)
            }
        }
    }
}
