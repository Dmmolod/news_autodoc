//
//  CellModel.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


// MARK: - Cell model -

/// Протокол модели для ячеек, используемой при построении `UICollectionView` секций.
///
/// Позволяет идентифицировать и сравнивать модели без конкретизации типа.
protocol CellModelProtocol {
    /// Уникальный идентификатор модели. Используется для диффинга и переиспользования.
    var identity: AnyHashable { get }
    
    /// Обёртка для сравнения объектов модели через `Equatable`, без знания конкретного типа.
    var equatable: AnyEquatable { get }
}

extension CellModelProtocol where Self: Equatable {
    /// Реализация `equatable`, если модель уже реализует `Equatable`.
    ///
    /// Оборачивает текущий объект в `AnyEquatable`.
    var equatable: AnyEquatable { AnyEquatable(self) }
}

// MARK: - Any -

/// Универсальная реализация модели ячейки без конкретных данных.
///
/// Используется в случаях, когда не требуется конфигурация содержимого,
/// но необходимо наличие `identity` для диффинга.
struct AnyCellModel: CellModelProtocol, Equatable {
    var identity: AnyHashable
}
