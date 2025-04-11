//
//  CellModel.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


// MARK: - Cell model -
protocol CellModelProtocol {
    var identity: AnyHashable { get }
    var equatable: AnyEquatable { get }
}

extension CellModelProtocol where Self: Equatable {
    var equatable: AnyEquatable { AnyEquatable(self) }
}

// MARK: - Any -
struct AnyCellModel: CellModelProtocol, Equatable {
    var identity: AnyHashable
}
