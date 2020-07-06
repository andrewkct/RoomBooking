//
//  ResultTests.swift
//  RoomBookingTests
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import XCTest
@testable import RoomBooking

class ResultTests: XCTestCase {
    var resultViewModel: ResultViewModel!
    
    override func setUp() { }
    
    override func tearDown() {
        resultViewModel = nil
    }
    
    func testLoadHtml() {
        let htmlName = "BookingSuccess"
        resultViewModel = ResultViewModel(htmlName)
        resultViewModel.load()
        
        resultViewModel.data.observe(on: self) { (htmlStr) in
            XCTAssertNotNil(htmlStr)
        }
        
        resultViewModel.errorMessage.observe(on: self) { (error) in
            XCTAssertEqual(error, "")
        }
    }
    
    func testInvalidPage() {
        let htmlName = "Invalid"
        resultViewModel = ResultViewModel(htmlName)
        resultViewModel.load()
        
        resultViewModel.data.observe(on: self) { (htmlStr) in
            XCTAssertEqual(htmlStr, "")
        }
        
        resultViewModel.errorMessage.observe(on: self) { (error) in
            XCTAssertEqual(error, "Invalid page")
        }
    }
    
    func testEmptyHtmlName() {
        let htmlName = ""
        resultViewModel = ResultViewModel(htmlName)
        resultViewModel.load()
        
        resultViewModel.data.observe(on: self) { (htmlStr) in
            XCTAssertEqual(htmlStr, "")
        }
        
        resultViewModel.errorMessage.observe(on: self) { (error) in
            XCTAssertEqual(error, "Invalid page")
        }
    }
}
