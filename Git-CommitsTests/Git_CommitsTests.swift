//
//  Git_CommitsTests.swift
//  Git-CommitsTests
//
//  Created by Abhishek Tyagi on 11/7/20.
//

import XCTest
@testable import Git_Commits
@testable import Alamofire

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
    
    //Mock approach to test your service decoding and assigning the result.
    
    func testHandleResponseData() {
        let service = CommitService()
        let expectation = self.expectation(description: "Commits")

        var listOfCommits: [Commit]? = nil
        service.handleResponseData(mockJsonData!) { success in
            listOfCommits = service.commits
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNotNil(listOfCommits)
            XCTAssertTrue(listOfCommits?.count ?? 0 == 1)
        }
    }
    
    private var mockJsonData: Data? {
        // I have stored the json response in this file, which i am using to test the data
        if let path = Bundle.main.path(forResource: "commits", ofType: "json") {
            do {
                  let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  return data
              }
        }
        return nil
    }
    
    func testCommitServiceFetchLatest_MockApproach() {
        let service = MockCommitService()
        var responseReceived: Bool = false
        
        let requestExpectation = self.expectation(description: "Commits")
        service.fetchLatest(mockJsonData: mockJsonData!) { success in
            responseReceived = success
            requestExpectation.fulfill()
        }

        waitForExpectations(timeout: 5) { (error) in
            XCTAssertTrue(responseReceived)
        }
    }
}

class MockCommitService: ObservableObject {
    @Published var commits: [Commit] = []
    
    let gitUrl = URL(string: "https://api.github.com/repos")!

    func fetchLatest(mockJsonData: Data, completion: @escaping (Bool) -> Void) {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)
        let mock = Mock(url: gitUrl, dataType: .json, statusCode: 200, data: [.get: mockJsonData])
        mock.register()
        
        sessionManager
            .request(gitUrl)
            .response { (response) in
                completion(true)
            }.resume()
    }
}
