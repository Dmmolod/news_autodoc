//
//  IdentifiableSection.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


// MARK: - Diffable sections&items
protocol IdentifiableSection: Hashable {
    associatedtype Identifier: Hashable
    associatedtype Item: Hashable
    
    var identifier: Identifier { get }
    var items: [Item] { get }
}

extension IdentifiableSection {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.items == rhs.items
    }
}
