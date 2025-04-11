//
//  UICollectionView+DataSource.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit
import Combine


/// Расширение для `Publisher`, где элементы вывода — это коллекции (`Collection`),
/// а ошибка не возникает.
///
/// Это расширение добавляет метод `bind`, который связывает исходный поток данных с `UICollectionViewDiffableDataSource`,
/// позволяя обновлять интерфейс с помощью диффабельного снапшота.
extension Publisher where Output: Collection, Failure == Never {
    
    /// Метод связывает данные из `Publisher` с `UICollectionViewDiffableDataSource`,
    /// чтобы обновить UI с использованием снапшота данных. Содержимое коллекции
    /// будет отражаться в коллекции (например, в `UICollectionView`).
    ///
    /// - Parameters:
    ///   - dataSource: `UICollectionViewDiffableDataSource`, с которым связываются данные.
    ///   - Section: Тип секции, который должен соответствовать протоколу `IdentifiableSection`.
    ///
    /// - Returns: Возвращает `AnyCancellable`, чтобы можно было отменить подписку при необходимости.
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
