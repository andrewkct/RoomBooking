//
//  SortViewModel.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 6/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

class SortViewModel {
    private(set) var data: Observable<[SortTableViewModel]> = Observable([])
    private var sortItems: [SortItem] = []
    private var previousIndexPath: IndexPath?
    
    init(_ sortTypes: [String: Bool]) {
        sortItems = sortTypes.enumerated().map({ (index, element) in
            if element.value {
                previousIndexPath = IndexPath(row: index, section: 0)
            }
            
            return SortItem(name: element.key, isSelected: element.value)
        })
        
        data.value = sortItems.map({ SortTableViewModel($0) })
    }
    
    func didSelectAt(_ indexPath: IndexPath) {
        // Ignore if current indexPath is same as previous indexPath
        if let checkPreviousIndexPath = previousIndexPath {
            if checkPreviousIndexPath == indexPath {
                return
            }
        }
        
        // Reset previous indexPath
        reset()
        
        var currentItem = sortItems[indexPath.row]
        currentItem.isSelected = true
        data.value[indexPath.row] = SortTableViewModel(currentItem)
        
        // Store current indexPath
        previousIndexPath = indexPath
    }
    
    func reset() {
        if let previousIndexPath = previousIndexPath {
            var previousItem = sortItems[previousIndexPath.row]
            previousItem.isSelected = false
            data.value[previousIndexPath.row] = SortTableViewModel(previousItem)
        }
        
        previousIndexPath = nil
    }
    
    func applyAndGetSortType() -> String? {
        if let previousIndexPath = previousIndexPath {
            let previousItem = sortItems[previousIndexPath.row]
            return previousItem.name
        }
        
        return nil
    }
}
