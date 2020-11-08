//
//  CommitService.swift
//  Git-Commits
//
//  Created by Abhishek Tyagi on 11/7/20.
//

import Foundation
import Alamofire

class CommitService: ObservableObject {
    
    @Published var commits: [Commit] = []
    
    init() {
        fetchLatest()
    }
    
    func fetchLatest() {
        let request = AF.request("https://api.github.com/repos/abhishek3322/Git-Commits/commits")
        request.response { (response) in
            guard let data = response.data else { return }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            
            do {
                let commits = try decoder.decode([Commit].self, from: data)
                self.commits = commits
            }catch {
                print("error: ", error)
            }
        }
    }
}
