//
//  SortTests.swift
//  RoomBookingTests
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import XCTest
@testable import RoomBooking

class SortTests: XCTestCase {
    var sortViewModel: SortViewModel!
    var sortTableViewModel: SortTableViewModel!
    var sortingTypes: [String: Bool]!
    
    override func setUp() {
        sortingTypes = ["Location": false, "Capacity": false, "Availability": false]
        sortViewModel = SortViewModel(sortingTypes)
    }
    
    override func tearDown() {
        sortViewModel = nil
        sortTableViewModel = nil
        sortingTypes = nil
    }
    
    func testSelectSort() {
        let indexPath = IndexPath(row: 0, section: 0)
        sortViewModel.didSelectAt(indexPath)
        
        sortViewModel.data.observe(on: self) { [weak self] (data) in
            if let data = data {
                self?.sortTableViewModel = data[indexPath.row]
                XCTAssertEqual(self?.sortTableViewModel.imgViewName, "ic_radio_active")
                XCTAssertNotNil(self?.sortTableViewModel.titleText, "Found nil")
            }
        }
    }
    
    func testApplySort() {
        testSelectSort()
        let selectedSortName = sortViewModel.applyAndGetSortType()
        XCTAssertEqual(self.sortTableViewModel.titleText, selectedSortName)
    }
    
    func testResetSort() {
        sortViewModel.reset()
        let selectedSortName = sortViewModel.applyAndGetSortType()
        XCTAssertEqual(selectedSortName, nil)
    }
    
    func testSortTableViewModel() {
        let sortItem = SortItem(name: "Location", isSelected: false)
        sortTableViewModel = SortTableViewModel(sortItem)
        XCTAssertEqual(sortTableViewModel.imgViewName, "ic_radio_inactive")
        XCTAssertEqual(sortTableViewModel.titleText, "Location")
    }
}
