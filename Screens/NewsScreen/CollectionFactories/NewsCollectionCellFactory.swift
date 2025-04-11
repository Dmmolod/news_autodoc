//
//  NewsCollectionCellFactory.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


struct NewsCollectionCellFactory {
    let cellRegistrator: CollectionCellRegistrator
    
    func news(bindings: NewsShortViewBindings) -> CollectionSectionItem {
        CellBuilderFactory.buildCombineItem(
            viewType: NewsShortView.self,
            wrapper: CancellableWrappedCollectionCell.self,
            registration: cellRegistrator,
            model: bindings
        )
    }
}
