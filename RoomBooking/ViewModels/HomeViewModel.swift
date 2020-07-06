//
//  HomeViewModel.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 5/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

class HomeViewModel {
    let navigationTitle = "Book a Room"
    let dateTitle = "Date"
    let timeslotTitle = "Timeslot"
    let noRecordsText = "No records"
    let okText = AppConstant.Text.ok
    
    private(set) var timeslots = [[String](), ["AM", "PM"]]
    private(set) var timeslot = ""
    private(set) var date = Date().toLocal()
    
    private(set) var sortingTypes = ["Location": false, "Capacity": false, "Availability": false]
    private var sortType = ""
    
    private var roomListService: RoomListService?
    private var roomListResponse = [RoomResponse]()
    private var rooms = [Room]()
    private(set) var data: Observable<[RoomTableViewModel]> = Observable([])
    private(set) var loading: Observable<Bool> = Observable(false)
    private(set) var errorMessage: Observable<String> = Observable("")
    
    init() {
        for i in 1 ... 12 {
            let time = i < 10 ? "0\(i):00" : "\(i):00"
            timeslots[0].append(time)
        }
        
        timeslot = "\(timeslots[0][7]) \(timeslots[1][0])"
        date = date.transformBy(time: timeslot)
        
        let session = NetworkSession()
        roomListService = RoomListService(session: session)
    }
    
    func load() {
        loading.value = true
        
        _ = roomListService?.getRoomList(completion: { [weak self] (result) in
            switch result {
            case .success(let roomListResponse, _):
                self?.roomListResponse = roomListResponse
                self?.filterByDate()
                
            case .error(_, _):
                self?.errorMessage.value = Connectivity.isConnectedToNetwork() ? "Server Error." : "Internet appears offline."
            }
            
            self?.loading.value = false
        })
    }
    
    func set(date: Date) {
        self.date = date
        filterByDate()
    }
    
    func sortBy(type: String?) {
        sortType = ""
        
        if let type = type {
            sortingTypes.forEach { (key, value) in
                if type.lowercased() == key.lowercased() {
                    sortingTypes[key] = true
                    sortType = type
                    filterByDate()
                    
                } else {
                    sortingTypes[key] = false
                }
            }
        
        } else {
            // Reset when there is no sorting applied
            sortingTypes.forEach { (key, value) in
                sortingTypes[key] = false
            }
            
            filterByDate()
        }
    }
    
    func filterByDate() {
        guard roomListResponse.count > 0 else {
            data.value = []
            return
        }
        
        let hourMinute = date.toHourMinute()
        rooms = []
        
        roomListResponse.forEach { (roomResponse) in
            if let availability = roomResponse.availability[hourMinute] {
                var room = Room()
                room.name = roomResponse.name
                room.level = roomResponse.level
                room.capacity = roomResponse.capacity
                room.isAvailable = Int(availability) == 1 ? true : false
                rooms.append(room)
            }
        }
        
        guard rooms.count > 0 else {
            data.value = []
            return
        }
        
        if !sortType.isEmpty {
            switch sortType.lowercased() {
            case "Capacity".lowercased():
                rooms.sort { (lhs, rhs) -> Bool in
                    let lhsInt = Int(lhs.capacity) ?? 0
                    let rhsInt = Int(rhs.capacity) ?? 0
                    return lhsInt > rhsInt
                }
                
            case "Availability".lowercased():
                rooms.sort { (lhs, rhs) -> Bool in
                    return lhs.isAvailable == true
                }
                
            default:
                // Location
                rooms.sort { (lhs, rhs) -> Bool in
                    return lhs.name < rhs.name
                }
            }
        }
        
        data.value = rooms.map({ RoomTableViewModel($0) })
    }
}
