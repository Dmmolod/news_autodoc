//
//  AnyEquatable.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


struct AnyEquatable: Equatable {
    private let _equals: (Any) -> Bool
    private let _value: Any
    
    init<T: Equatable>(_ value: T) {
        _value = value
        _equals = { other in
            guard let otherValue = other as? T else {
                return false
            }
            
            return value == otherValue
        }
    }
    
    static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs._equals(rhs._value)
    }
}
