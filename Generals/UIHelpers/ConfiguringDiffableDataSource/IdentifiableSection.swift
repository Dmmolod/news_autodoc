//
//  IdentifiableSection.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


// MARK: - Diffable sections&items
/// Протокол, описывающий секцию, используемую в diffable data source.
///
/// Позволяет описывать данные как массив секций, каждая из которых имеет свой `identifier`
/// и список элементов `items`. Используется при построении snapshot'ов.
protocol IdentifiableSection: Hashable {
    /// Уникальный идентификатор секции.
    associatedtype Identifier: Hashable
    
    /// Тип элемента внутри секции.
    associatedtype Item: Hashable
    
    /// Идентификатор текущей секции.
    var identifier: Identifier { get }
    
    /// Элементы, содержащиеся в данной секции.
    var items: [Item] { get }
}

extension IdentifiableSection {
    /// Реализация `hash(into:)` на основе только идентификатора секции.
    ///
    /// Это позволяет использовать секции в diffable snapshot без учёта
    /// изменения содержимого (`items`), что даёт более стабильные анимации.
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    /// Сравнение секций по содержимому.
    ///
    /// Секции считаются равными, если содержат одинаковые `items`.
    /// Используется diffable data source для определения, изменились ли данные в секции.
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.items == rhs.items
    }
}
