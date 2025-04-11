//
//  ConfiguringDiffableDataSource.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit
import Combine


// MARK: - Вспомогательная настройка секций и коллекций

// MARK: - Получение ячеек -
extension UICollectionView {
    func dequeue<Cell: UICollectionViewCell>(at indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: Cell.reuseId, for: indexPath) as! Cell
    }
}

extension UICollectionReusableView {
    static var reuseId: String { String(describing: self) }
}

// MARK: - Обертка для ячеек -
public protocol CollectionCellWrapper: UICollectionViewCell {
    associatedtype View: UIView
    var wrappedView: View { get }
}

public protocol CancellableCollectionCellWrapper: CollectionCellWrapper {
    var cancellabels: [AnyCancellable] { get set }
}

class WrappedCollectionViewCell<WrappedView: UIView>: UICollectionViewCell, CollectionCellWrapper {
    let wrappedView = WrappedView()
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(wrappedView)
        
        wrappedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wrappedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            wrappedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            wrappedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wrappedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

class CancellableWrappedCollectionCell<WrappedView: UIView>: WrappedCollectionViewCell<WrappedView>, CancellableCollectionCellWrapper {
    var cancellabels: [AnyCancellable] = []
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellabels.forEach({ $0.cancel() })
        cancellabels = []
    }
}

// MARK: - Дата сорс -
public typealias ConfiguringDiffableDataSource<Section: Hashable> = UICollectionViewDiffableDataSource<Section, CollectionSectionItem>

extension ConfiguringDiffableDataSource {
    public static func makeDataSource<Section: Hashable>(collectionView: UICollectionView) -> ConfiguringDiffableDataSource<Section> {
        return ConfiguringDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                return item.cellBuilder.buildCell(in: collectionView, for: indexPath)
            }
        )
    }
}

// MARK: - Section item -
public struct CollectionSectionItem: Hashable {
    public var identity: AnyHashable {
        "\(cellBuilder.model.identity)" + "\(type(of: cellBuilder.model))"
    }
    
    public let cellBuilder: any CellBuilderProtocol
    
    public init(cellBuilder: any CellBuilderProtocol) {
        self.cellBuilder = cellBuilder
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
    
    public static func == (lhs: CollectionSectionItem, rhs: CollectionSectionItem) -> Bool {
        lhs.cellBuilder.model.equatable == rhs.cellBuilder.model.equatable
    }
}

// MARK: - Cell model -
public protocol CellModelProtocol {
    var identity: AnyHashable { get }
    var equatable: AnyEquatable { get }
}

public extension CellModelProtocol where Self: Equatable {
    var equatable: AnyEquatable { AnyEquatable(self) }
}

// MARK: - Cell builder -
public protocol CellBuilderProtocol {
    associatedtype Model: CellModelProtocol
    
    var model: Model { get }
    var cellRegistrator: CollectionCellRegistrator { get }
    
    func buildCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell
}

struct CellBuilderConfiguration<Wrapper: CollectionCellWrapper> {
    let wrapper: Wrapper.Type
    let cellRegistration: CollectionCellRegistrator
}

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

// MARK: - Any configuring
public protocol AnyCellViewProtocol {}

public struct AnyCellModel: CellModelProtocol, Equatable {
    public var identity: AnyHashable
}

struct AnyCellBuilder<Wrapper: CollectionCellWrapper, View: AnyCellViewProtocol>: CellBuilderProtocol {
    let wrapper: Wrapper.Type
    public var cellRegistrator: CollectionCellRegistrator
    public let model: AnyCellModel
    
    func buildCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        cellRegistrator.registerCell(wrapper.self, in: collectionView)
        let cell: Wrapper = collectionView.dequeue(at: indexPath)
        return cell
    }
}

// MARK: - Registration cells -
protocol CollectionCellRegistratorProtocol {
    var registeredCells: Set<AnyHashable> { get set }
    
    func registerCell<Cell: UICollectionViewCell>(_ cellType: Cell.Type, in collectionView: UICollectionView)
}

public final class CollectionCellRegistrator {
    var registeredCells: Set<AnyHashable> = []
    
    func registerCell<Cell: UICollectionViewCell>(_ cellType: Cell.Type, in collectionView: UICollectionView) {
        guard !registeredCells.contains(cellType.reuseId) else {
            return
        }
        
        collectionView.register(cellType, forCellWithReuseIdentifier: cellType.reuseId)
        registeredCells.insert(cellType.reuseId)
    }
}

// MARK: - Configuring view -
public protocol ConfiguringView: UIView {
    associatedtype Model: CellModelProtocol
    func configure(with model: Model)
}

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

// MARK: - Combine configuring view
public protocol CombineConfiguringView: UIView {
    associatedtype Model: CellModelProtocol
    func configure(with model: Model) -> AnyCancellable
}

public struct CombineCellBuilder<Wrapper: CancellableCollectionCellWrapper, View: CombineConfiguringView>: CellBuilderProtocol where Wrapper.View == View {
    public let wrapper: Wrapper.Type
    public var cellRegistrator: CollectionCellRegistrator
    public let model: View.Model
   
    public func buildCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        cellRegistrator.registerCell(wrapper.self, in: collectionView)
        
        let cell: Wrapper = collectionView.dequeue(at: indexPath)
        cell.wrappedView.configure(with: model).store(in: &cell.cancellabels)
        return cell
    }
}

// MARK: - Equatable
public struct AnyEquatable: Equatable {
    private let _equals: (Any) -> Bool
    private let _value: Any
    
    public init<T: Equatable>(_ value: T) {
        _value = value
        _equals = { other in
            guard let otherValue = other as? T else {
                return false
            }
            
            return value == otherValue
        }
    }
    
    public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs._equals(rhs._value)
    }
}
