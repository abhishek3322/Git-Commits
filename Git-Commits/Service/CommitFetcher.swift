//
//  CommitFetcher.swift
//  Git-Commits
//
//  Created by Abhishek Tyagi on 11/15/20.
//

import Foundation
import Alamofire

protocol CommitFetcherDelegate {
    func fetch(completion: @escaping (Data?, Error?) -> Void)
}

class CommitFetcher: CommitFetcherDelegate {
    let request: Alamofire.DataRequest
    init(request: Alamofire.DataRequest) {
        self.request = request
    }

    func fetch(completion: @escaping (Data?, Error?) -> Void) {
        request.response { (response) in
            guard let data = response.data else {
                completion(nil, response.error)
                return
            }
            completion(data, nil)
        }
    }
}
