//
//  Array+Cancellable.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Combine


extension Array: @retroactive Cancellable where Element == Cancellable {
    public func cancel() {
        forEach { $0.cancel() }
    }
}
