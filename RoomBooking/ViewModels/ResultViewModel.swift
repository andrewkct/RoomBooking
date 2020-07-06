//
//  ResultViewModel.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

class ResultViewModel {
    let navigationTitle = "Book a Room"
    let invalidPageError = "Invalid page"
    let okText = AppConstant.Text.ok
    private(set) var data: Observable<String> = Observable("")
    private(set) var errorMessage: Observable<String> = Observable("")
    
    private var htmlName: String
    
    init(_ htmlName: String) {
        self.htmlName = htmlName
    }
    
    func load() {
        guard !htmlName.isEmpty else {
            errorMessage.value = invalidPageError
            return
        }
        
        guard let htmlFile = Bundle.main.path(forResource: htmlName, ofType: "html") else {
            errorMessage.value = invalidPageError
            return
        }
    
        do {
            let htmlStr = try String(contentsOfFile: htmlFile, encoding: .utf8)
            data.value = htmlStr
        
        } catch {
            errorMessage.value = invalidPageError
        }
    }
}
