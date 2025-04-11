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

/// Тип-алиас для `UICollectionViewDiffableDataSource` с элементами типа `CollectionSectionItem`.
typealias ConfiguringDiffableDataSource<Section: Hashable> = UICollectionViewDiffableDataSource<Section, CollectionSectionItem>

extension ConfiguringDiffableDataSource {
    /// Создаёт и возвращает настроенный `UICollectionViewDiffableDataSource`.
    ///
    /// - Parameter collectionView: Коллекция, к которой привязывается дата сорс.
    /// - Returns: Объект `ConfiguringDiffableDataSource`, готовый к использованию.
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

/// Обёртка над ячейкой коллекции для использования с diffable snapshot.
///
/// Используется как элемент в секциях при конфигурации `UICollectionViewDiffableDataSource`.
struct CollectionSectionItem: Hashable {
    
    /// Уникальный идентификатор для diffable-алгоритма.
    /// Комбинирует `identity` и тип модели.
    var identity: AnyHashable {
        "\(cellBuilder.model.identity)" + "\(type(of: cellBuilder.model))"
    }
    
    /// Билдер, создающий и конфигурирующий ячейку.
    let cellBuilder: any CellBuilderProtocol
    
    /// Инициализирует элемент секции с указанным билдером.
    ///
    /// - Parameter cellBuilder: Объект, реализующий `CellBuilderProtocol`.
    init(cellBuilder: any CellBuilderProtocol) {
        self.cellBuilder = cellBuilder
    }
    
    /// Хэширует объект на основе `identity`.
    func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
    
    /// Сравнение двух элементов коллекции.
    ///
    /// Сравниваются через `equatable` обёртку модели.
    static func == (lhs: CollectionSectionItem, rhs: CollectionSectionItem) -> Bool {
        lhs.cellBuilder.model.equatable == rhs.cellBuilder.model.equatable
    }
}
