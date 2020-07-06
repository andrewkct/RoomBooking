//
//  Observable.swift
//  RoomBooking
//
//  Created by Andrew Khoo on 5/7/20.
//  Copyright © 2020 Andrew Khoo. All rights reserved.
//

import Foundation

final class Observable<T> {
    typealias CompletionHandler = (T?) -> Void
    private var observers = [Observer<T>]()

    var value: T {
        didSet {
            notify()
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func observe(on observer: AnyObject, completion: @escaping CompletionHandler) {
        observers.append(Observer(observer: observer, completion: completion))
        completion(value)
    }
    
    func notify() {
        observers.forEach({ $0.completion(value) })
    }
    
    func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    func removeAll() {
        observers.removeAll()
    }
}
