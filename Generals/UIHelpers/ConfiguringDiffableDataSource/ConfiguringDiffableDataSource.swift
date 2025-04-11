//
//  ConfiguringDiffableDataSource.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit
import Combine


// MARK: - Вспомогательная настройка секций и коллекций
// MARK: - Дата сорс -
typealias ConfiguringDiffableDataSource<Section: Hashable> = UICollectionViewDiffableDataSource<Section, CollectionSectionItem>

extension ConfiguringDiffableDataSource {
    static func makeDataSource<Section: Hashable>(collectionView: UICollectionView) -> ConfiguringDiffableDataSource<Section> {
        return ConfiguringDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                return item.cellBuilder.buildCell(in: collectionView, for: indexPath)
            }
        )
    }
}

// MARK: - Section item -
struct CollectionSectionItem: Hashable {
    var identity: AnyHashable {
        "\(cellBuilder.model.identity)" + "\(type(of: cellBuilder.model))"
    }
    
    let cellBuilder: any CellBuilderProtocol
    
    init(cellBuilder: any CellBuilderProtocol) {
        self.cellBuilder = cellBuilder
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
    
    static func == (lhs: CollectionSectionItem, rhs: CollectionSectionItem) -> Bool {
        lhs.cellBuilder.model.equatable == rhs.cellBuilder.model.equatable
    }
}
