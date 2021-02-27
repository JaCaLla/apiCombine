//
//  APIManagerUT.swift
//  apiCombineTests
//
//  Created by Javier Calatrava on 20/2/21.
//
@testable import apiCombine
import Combine
import XCTest

class APIManagerUT: CombineTestCase {

    var apiManager: APIManager!

    override func setUp() {
        super.setUp()
        self.apiManager = APIManager()
    }

    func testFetchParksOriginal() throws {
        let exp = expectation(description: "Test finished")
        
        apiManager.fetchParksOriginal { result in
            switch result {
            case .success(let parksResponseAPI):
                XCTAssertEqual(parksResponseAPI.start, "0")
                XCTAssertEqual(parksResponseAPI.total, "468")
                XCTAssertEqual(parksResponseAPI.data.count, 50)
            case .failure:
                XCTFail()
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchParks() throws {

        var parksResponseAPI: ParksResponseAPI?
        var completion: Subscribers.Completion<HTTPError>?

        let exp = expectation(description: "Publisher finished")

        apiManager.fetchParks()
            .sink(receiveCompletion: { completion = $0 },
                  receiveValue: {
                      parksResponseAPI = $0
                      exp.fulfill()
                  })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertEqual(parksResponseAPI?.data.count, 50)
        XCTAssertNotNil(completion)
        XCTAssertEqual(completion, .finished)
    }

}
