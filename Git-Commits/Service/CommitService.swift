//
//  CommitService.swift
//  Git-Commits
//
//  Created by Abhishek Tyagi on 11/7/20.
//

import Foundation
import Alamofire

enum ServerError: Error {
    case somethingWentWrong
}

class CommitService: ObservableObject {
    
    let gitUrl = "https://api.github.com/repos/"
    let sinceTime = "2020-01-01T0:00:00Z"

    @Published var commits: [Commit] = []
    @Published var isFetchingCommits: Bool = false
    var repoInfo: [String: String] = [:]
    
    var fetcher: CommitFetcher?
    
    func fetchLatest(completion: ( (Data?, Error?) -> Void)? = nil) {
        guard let fetcher = self.fetcher else { return } //Should throw error for better user experience.
        
        isFetchingCommits = true
        fetcher.fetch { data, error in
            self.isFetchingCommits = false
            if let error = error {
                print(error.localizedDescription)
            }
            else if let data = data {
                self.handleResponseData(data)
            }
            
            if let completion = completion {
                completion(data, error)
            }
        }
    }
    
    func updateCommitFetcher(for repo: String, author: String) {
        repoInfo = ["name": repo, "author": author]
        let request = AF.request("\(gitUrl)\(author)/\(repo)/commits?since=\(sinceTime)")
        fetcher = CommitFetcher(request: request)
    }
    
    func handleResponseData(_ data: Data) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        do {
            let commits = try decoder.decode([Commit].self, from: data)
            self.commits = commits
            
        }catch {
            print("Error")
        }
    }
    
    func validateInformation(author: String, repo: String) -> Bool {
        return author.count > 3 && repo.count > 3
    }
}
