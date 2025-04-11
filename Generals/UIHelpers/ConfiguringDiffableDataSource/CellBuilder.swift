//
//  CellBuilder.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit


// MARK: - Builder -

/// Протокол, описывающий сборщик ячеек для UICollectionView.
protocol CellBuilderProtocol {
    associatedtype Model: CellModelProtocol
    
    /// Модель, с которой работает билдер.
    var model: Model { get }
    
    /// Регистрирует ячейки в UICollectionView.
    var cellRegistrator: CollectionCellRegistrator { get }
    
    /// Метод сборки и конфигурации ячейки.
    ///
    /// - Parameters:
    ///   - collectionView: Коллекция, в которую будет добавлена ячейка.
    ///   - indexPath: Позиция ячейки в коллекции.
    /// - Returns: Сконфигурированная ячейка `UICollectionViewCell`.
    func buildCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell
}

// MARK: - Builder configuration -

/// Конфигурация для сборщика ячеек.
struct CellBuilderConfiguration<Wrapper: CollectionCellWrapper> {
    /// Тип враппера для ячейки.
    let wrapper: Wrapper.Type
    
    // Объект, отвечающий за регистрацию ячеек.
    let cellRegistration: CollectionCellRegistrator
}

// MARK: - Builder factory -

/// Фабрика для создания различных конфигураций ячеек.
struct CellBuilderFactory {
    
    /// Создаёт элемент коллекции без конфигурации модели.
    ///
    /// - Parameters:
    ///   - viewType: Тип вьюхи.
    ///   - wrapper: Тип враппера для ячейки.
    ///   - registration: Объект регистрации ячеек.
    ///   - identity: Уникальный идентификатор элемента.
    /// - Returns: `CollectionSectionItem` с готовым билдером.
    static func buildAnyViewItem<View: AnyCellViewProtocol, Wrapper: CollectionCellWrapper>(
        viewType: View.Type,
        wrapper: Wrapper.Type,
        registration: CollectionCellRegistrator,
        identity: AnyHashable
    ) -> CollectionSectionItem {
        let builder = AnyCellBuilder<Wrapper, View>(
            wrapper: wrapper,
            cellRegistrator: registration,
            model: AnyCellModel(identity: identity)
        )
        
        return CollectionSectionItem(cellBuilder: builder)
    }
    
    /// Создаёт элемент коллекции с конфигурацией через модель.
    ///
    /// - Parameters:
    ///   - viewType: Тип вьюхи, поддерживающей конфигурацию.
    ///   - wrapper: Тип враппера для ячейки.
    ///   - registration: Объект регистрации ячеек.
    ///   - model: Модель для конфигурации вьюхи.
    /// - Returns: `CollectionSectionItem` с готовым билдером.
    static func buildConfiguringItem<View: ConfiguringView, Wrapper: CollectionCellWrapper>(
        viewType: View.Type,
        wrapper: Wrapper.Type,
        registration: CollectionCellRegistrator,
        model: View.Model
    ) -> CollectionSectionItem where Wrapper.View == View {
        let builder = CellBuilder<Wrapper, View>(
            wrapper: wrapper,
            cellRegistrator: registration,
            model: model
        )
        
        return CollectionSectionItem(cellBuilder: builder)
    }
    
    /// Создаёт элемент коллекции с конфигурацией через Combine.
    ///
    /// - Parameters:
    ///   - viewType: Тип вьюхи, поддерживающей Combine-конфигурацию.
    ///   - wrapper: Тип враппера с поддержкой отмены подписок.
    ///   - registration: Объект регистрации ячеек.
    ///   - model: Модель для конфигурации вьюхи.
    /// - Returns: `CollectionSectionItem` с готовым билдером.
    static func buildCombineItem<View: CombineConfiguringView, Wrapper: CancellableCollectionCellWrapper>(
        viewType: View.Type,
        wrapper: Wrapper.Type,
        registration: CollectionCellRegistrator,
        model: View.Model
    ) -> CollectionSectionItem where Wrapper.View == View {
        let builder = CombineCellBuilder<Wrapper, View>(
            wrapper: wrapper,
            cellRegistrator: registration,
            model: model
        )
        
        return CollectionSectionItem(cellBuilder: builder)
    }
}

// MARK: - Any builder -

/// Билдер для ячеек без конфигурации модели.
struct AnyCellBuilder<Wrapper: CollectionCellWrapper, View: AnyCellViewProtocol>: CellBuilderProtocol {
    let wrapper: Wrapper.Type
    let cellRegistrator: CollectionCellRegistrator
    let model: AnyCellModel
    
    func buildCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        cellRegistrator.registerCell(wrapper.self, in: collectionView)
        
        let cell: Wrapper = collectionView.dequeue(at: indexPath)
        return cell
    }
}

// MARK: - Basic builder -

/// Билдер для ячеек с типизированной моделью.
struct CellBuilder<Wrapper: CollectionCellWrapper, View: ConfiguringView>: CellBuilderProtocol where Wrapper.View == View {
    let wrapper: Wrapper.Type
    let cellRegistrator: CollectionCellRegistrator
    let model: View.Model
    
    func buildCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        cellRegistrator.registerCell(wrapper.self, in: collectionView)
        
        let cell: Wrapper = collectionView.dequeue(at: indexPath)
        cell.wrappedView.configure(with: model)
        return cell
    }
}

// MARK: - Combine builder -

/// Билдер для ячеек с конфигурацией через Combine.
struct CombineCellBuilder<Wrapper: CancellableCollectionCellWrapper, View: CombineConfiguringView>: CellBuilderProtocol where Wrapper.View == View {
    let wrapper: Wrapper.Type
    let cellRegistrator: CollectionCellRegistrator
    let model: View.Model
    
    func buildCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        cellRegistrator.registerCell(wrapper.self, in: collectionView)
        
        let cell: Wrapper = collectionView.dequeue(at: indexPath)
        cell.wrappedView.configure(with: model).store(in: &cell.cancellabels)
        return cell
    }
}
