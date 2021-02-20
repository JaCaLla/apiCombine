//
//  APIManagerUT.swift
//  apiCombineTests
//
//  Created by Javier Calatrava on 20/2/21.
//
@testable import apiCombine
import XCTest

class APIManagerUT: XCTestCase {

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

}
