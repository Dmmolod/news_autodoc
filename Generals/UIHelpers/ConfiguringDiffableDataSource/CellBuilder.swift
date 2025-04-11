//
//  CellBuilder.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit

// MARK: - Builder -
protocol CellBuilderProtocol {
    associatedtype Model: CellModelProtocol
    
    var model: Model { get }
    var cellRegistrator: CollectionCellRegistrator { get }
    
    func buildCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell
}

// MARK: - Builder configuration -
struct CellBuilderConfiguration<Wrapper: CollectionCellWrapper> {
    let wrapper: Wrapper.Type
    let cellRegistration: CollectionCellRegistrator
}

// MARK: - Builder factory -
struct CellBuilderFactory {
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

