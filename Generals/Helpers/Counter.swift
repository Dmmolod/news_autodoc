//
//  Counter.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


final class Counter {
    private(set) var value: Int = 0
    
    func next() -> Int {
        value += 1
        return value
    }
    
    func previous() -> Int {
        value -= 1
        return value
    }
    
    func reset() {
        value = 0
    }
}
