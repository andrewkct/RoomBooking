//
//  ScanQRTests.swift
//  RoomBookingTests
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import XCTest
@testable import RoomBooking

class ScanQRTests: XCTestCase {
    var scanQRViewModel: ScanQRViewModel!
    
    override func setUp() {
        scanQRViewModel = ScanQRViewModel()
    }
    
    override func tearDown() {
        scanQRViewModel = nil
    }
    
    func testValidQR() {
        let code = "dGVzdF9zdWNjZXNz"
        scanQRViewModel.verifyQR(code: code, scanType: .qr)
        
        scanQRViewModel.data.observe(on: self) { (decodedQr) in
            XCTAssertEqual(decodedQr, "BookingSuccess")
        }
        
        scanQRViewModel.errorMessage.observe(on: self) { (error) in
            XCTAssertEqual(error, "")
        }
    }
    
    func testInvalidQRFormat() {
        let code = "InvalidQRFormat"
        scanQRViewModel.verifyQR(code: code, scanType: .qr)
        
        scanQRViewModel.data.observe(on: self) { (decodedQr) in
            XCTAssertEqual(decodedQr, "")
        }
        
        scanQRViewModel.errorMessage.observe(on: self) { (error) in
            XCTAssertEqual(error, "Invalid QR format")
        }
    }
    
    func testInvalidQR() {
        let code = "dGVzdF9zdWNjZXNz"
        scanQRViewModel.verifyQR(code: code, scanType: .ean13)
        
        scanQRViewModel.data.observe(on: self) { (decodedQr) in
            XCTAssertEqual(decodedQr, "")
        }
        
        scanQRViewModel.errorMessage.observe(on: self) { (error) in
            XCTAssertEqual(error, "Invalid QR")
        }
    }
}
