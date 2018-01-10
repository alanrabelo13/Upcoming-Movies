//
//  Upcoming_MoviesTests.swift
//  Upcoming MoviesTests
//
//  Created by Alan Rabelo Martins on 08/01/2018.
//  Copyright © 2018 Alan Rabelo Martins. All rights reserved.
//

import XCTest
@testable import Upcoming_Movies

class Upcoming_MoviesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadingUpcomingDataFromAPI() {
        
        let expectation = self.expectation(description: "Loaded data from API")
        
        Movie.all(forPage: 1) { (movies) in
            if movies.isEmpty {
                XCTFail("No movies found")
            } else {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)

    }
    
}
