//
//  ScanQRViewModel.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation
import AVFoundation

class ScanQRViewModel {
    let navigationTitle = "ScanQR"
    let qrSetupError = "Scanning not supported"
    let qrFormatError = "Invalid QR format"
    let qrInvalidError = "Invalid QR"
    let okText = AppConstant.Text.ok
    let cancelText = AppConstant.Text.cancel
    
    private(set) var data: Observable<String> = Observable("")
    private(set) var errorMessage: Observable<String> = Observable("")
    private let validQRs = ["dGVzdF9zdWNjZXNz", "dGVzdF9mYWlsZWQ="]
    private let result_success = "test_success"
    private let result_failed = "test_failed"
    private let booking_sucess = "BookingSuccess"
    private let booking_failed = "BookingFailed"
    
    func verifyQR(code: String, scanType: AVMetadataObject.ObjectType) {
        guard scanType == .qr else {
            errorMessage.value = qrInvalidError
            return
        }
        
        guard validQRs.contains(code) else {
            errorMessage.value = qrFormatError
            return
        }
        
        if let decodedQr = code.base64Decoded() {
            data.value = decodedQr.lowercased() == result_success.lowercased() ? booking_sucess : booking_failed
        }
    }
}
