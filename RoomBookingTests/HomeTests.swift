//
//  HomeTests.swift
//  RoomBookingTests
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import XCTest
@testable import RoomBooking

class HomeTests: XCTestCase {
    var homeViewModel: HomeViewModel!
    
    override func setUp() {
        homeViewModel = HomeViewModel()
    }
    
    override func tearDown() {
        homeViewModel = nil
    }
    
    func testDefaultDate() {
        XCTAssertEqual(homeViewModel.date, Date().toLocal().transformBy(time: "08:00 AM"))
    }
    
    func testDefaultTimeslot() {
        XCTAssertEqual(homeViewModel.timeslot, "08:00 AM")
    }
    
    func testRoomListApi() {
        let asyncExpectation = expectation(description: "Async Block Executed")
        let session = NetworkSession()
        let roomListService = RoomListService(session: session)
        
        _ = roomListService.getRoomList { (result) in
            switch result {
            case .success(let roomListResponse, _):
                XCTAssertGreaterThan(roomListResponse.count, 0)
                asyncExpectation.fulfill()
                
            case .error(let error, _):
                XCTAssertNotNil(error)
                asyncExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
