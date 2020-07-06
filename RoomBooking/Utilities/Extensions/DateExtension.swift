//
//  DateExtension.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

extension Date {
    func toLocal() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        let value = Int(timeZoneOffset)
        
        guard let localDate = Calendar.current.date(byAdding: .second, value: value, to: nowUTC) else {
            return Date()
        }
        
        return localDate
    }
    
    // Output: 1st Jul 2020
    func toOrdinal() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let dateComponents = calendar.component(.day, from: self)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        
        let day = numberFormatter.string(from: dateComponents as NSNumber) ?? ""
        let monthYear = dateFormatter.string(from: self)
        
        return String(format: "%@ %@", day, monthYear)
    }
    
    // Output: 18:00
    func toHourMinute() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return dateFormatter.string(from: self)
    }
    
    func transformBy(time: String) -> Date {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        timeFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let timeDate = timeFormatter.date(from: time) else {
            return self
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        
        var changeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)
        changeComponents.year = dateComponents.year
        changeComponents.month = dateComponents.month
        changeComponents.day = dateComponents.day
        
        guard let transformedDate = calendar.date(from: changeComponents) else {
            return self
        }
        
        return transformedDate
    }
}
