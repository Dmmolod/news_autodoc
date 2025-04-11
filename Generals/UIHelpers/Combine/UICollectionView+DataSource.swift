//
//  UICollectionView+DataSource.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit
import Combine


extension Publisher where Output: Collection, Failure == Never {
    func bind<Section: IdentifiableSection>(
        using dataSource: UICollectionViewDiffableDataSource<Section, Section.Item>,
    ) -> AnyCancellable where Output.Element == Section {
        receive(on: DispatchQueue.main)
            .sink { sections in
                var snapshot = NSDiffableDataSourceSnapshot<Section, Section.Item>()
                snapshot.appendSections(Array(sections))
                
                for section in sections {
                    snapshot.appendItems(section.items, toSection: section)
                }
                
                dataSource.apply(snapshot, animatingDifferences: true)
            }
    }
}
