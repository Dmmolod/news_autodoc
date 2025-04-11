//
//  CellRegistrator.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit


// MARK: - Registration cells -
protocol CollectionCellRegistratorProtocol {
    var registeredCells: Set<AnyHashable> { get set }
    
    func registerCell<Cell: UICollectionViewCell>(_ cellType: Cell.Type, in collectionView: UICollectionView)
}

final class CollectionCellRegistrator {
    var registeredCells: Set<AnyHashable> = []
    
    init() {}
    
    func registerCell<Cell: UICollectionViewCell>(_ cellType: Cell.Type, in collectionView: UICollectionView) {
        guard !registeredCells.contains(cellType.reuseId) else {
            return
        }
        
        collectionView.register(cellType, forCellWithReuseIdentifier: cellType.reuseId)
        registeredCells.insert(cellType.reuseId)
    }
}
