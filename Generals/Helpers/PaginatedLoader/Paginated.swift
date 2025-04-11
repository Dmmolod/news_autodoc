//
//  Paginated.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


public enum Paginated<Item> {
    case loaded([Item])
    case loading
    case loadMore(_ current: [Item])
}

public extension Paginated {
    var isLoading: Bool {
        switch self {
        case .loading, .loadMore:
            return true
        case .loaded:
            return false
        }
    }
    
    var items: [Item] {
        switch self {
        case .loaded(let items), .loadMore(let items):
            return items
        case .loading:
            return []
        }
    }
    
    func update(with items: [Item]) -> Paginated {
        switch self {
        case .loadMore, .loading:
            return Paginated.loaded(items)
        case .loaded(let currentItems):
            return Paginated.loaded(currentItems + items)
        }
    }
    
    func map<T>(_ transform: (Item) -> T) -> Paginated<T> {
        switch self {
        case .loadMore(let items):
            return .loadMore(items.map(transform))
        case .loaded(let items):
            return .loaded(items.map(transform))
        case .loading:
            return .loading
        }
    }
}

extension Paginated: Equatable where Item: Equatable {}
