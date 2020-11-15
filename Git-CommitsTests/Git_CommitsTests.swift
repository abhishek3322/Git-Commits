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
    private var successMethodCalled = false
    private var errorMethodCalled = false
    
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
    
    var mockRequest: Alamofire.DataRequest {
        return AF.request("mockUrl")

    }

    //Mock approach to test your service decoding and assigning the result.
    func testHandleResponseData() {
        let service = CommitService()

        service.handleResponseData(mockJsonData!)

        XCTAssertNotNil(service.commits)
        XCTAssertTrue(service.commits.count == 1)
    }
    
    func testServiceFetchLatest_successScenario() {
        let service = CommitService()
        let mockCommitFetcher = MockCommitFetcher(request: mockRequest, response: (mockJsonData!, nil))
        service.fetcher = mockCommitFetcher
        service.fetchLatest { data, error in
            XCTAssertTrue(service.commits.count == 1)
            XCTAssertNotNil(data)
            XCTAssertNil(error)
        }
    }
    
    func testServiceFetchLatest_errorScenario() {
        let service = CommitService()
        let mockCommitFetcher = MockCommitFetcher(request: mockRequest, response: (nil, ServerError.somethingWentWrong))
        service.fetcher = mockCommitFetcher
        service.fetchLatest { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            XCTAssertTrue(error! as! ServerError == ServerError.somethingWentWrong)
        }
    }
    
    func testUpdateCommitFetcher_isNotNil() {
        let service = CommitService()

        service.updateCommitFetcher(for: "repo", author: "author")
        
        XCTAssertNotNil(service.fetcher)
    }
    
    func testUpdateCommitFetcher_isNil() {
        let service = CommitService()
        XCTAssertNil(service.fetcher)
    }
    
    func testValidateRepoInfo_isValid() {
        let service = CommitService()

        let isValid = service.validateInformation(author: "repo", repo: "author")
        
        XCTAssertTrue(isValid)
    }
    
    func testValidateRepoInfo_isNotvalid() {
        let service = CommitService()
       
        let isValid = service.validateInformation(author: "re", repo: "a")
        XCTAssertFalse(isValid)
        
        let isValid1 = service.validateInformation(author: "", repo: "")
        XCTAssertFalse(isValid1)
        
        let isValid2 = service.validateInformation(author: "repo", repo: "123")
        XCTAssertFalse(isValid2)
    }
}

class MockCommitFetcher: CommitFetcher {

    typealias MockResponse = (Data?, Error?)
    let mockedResponse: MockResponse

    init(request: Alamofire.DataRequest, response: MockResponse) {
        mockedResponse = response
        super.init(request: request)
    }

    override func fetch(completion: @escaping (Data?, Error?) -> Void) {
        completion(mockedResponse.0, mockedResponse.1)
    }
}
