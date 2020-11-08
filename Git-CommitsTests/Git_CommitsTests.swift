//
//  Git_CommitsTests.swift
//  Git-CommitsTests
//
//  Created by Abhishek Tyagi on 11/7/20.
//

import XCTest
@testable import Git_Commits

class Git_CommitsTests: XCTestCase {
    
    func testCommitServiceFetchLatest() {
        let service = CommitService()
        let expectation = self.expectation(description: "Commits")

        var listOfCommits: [Commit]? = nil
        service.fetchLatest(author: "Alamofire", repo: "Alamofire") { success in
            listOfCommits = service.commits
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNotNil(listOfCommits)
            XCTAssertTrue(listOfCommits?.count ?? 0 > 25)
        }
    }
}
