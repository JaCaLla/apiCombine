//
//  CombineTestCase.swift
//  NPSTests
//
//  Created by Javier Calatrava on 8/2/21.
//

import Combine
import XCTest
@testable import apiCombine

class CombineTestCase: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        super.tearDown()
        cancellables = nil
    }
}
