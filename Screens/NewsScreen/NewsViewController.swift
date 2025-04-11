//
//  NewsViewController.swift
//  NewsAutodoc
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import UIKit
import Combine


protocol NewsViewControllerBindings {
    var newsSectionsPublisher: AnyPublisher<[NewsCollectionSection], Never> { get }
}

final class NewsViewController: CommonInitViewController {
    private var collectionView: UICollectionView!
    private var dataSource: NewsCollectionDataSource!
    
    func bind(to bindings: NewsViewControllerBindings) -> Cancellable {
        return [
            bindings.newsSectionsPublisher.bind(using: dataSource)
        ]
    }
    
    override func commonInit() {
        super.commonInit()
        
        collectionView = makeCollectionView()
        dataSource = makeDataSource(collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
    }
}

private typealias NewsCollectionDataSource = ConfiguringDiffableDataSource<NewsCollectionSection>

private extension NewsViewController {
    private func makeCollectionView() -> UICollectionView {
        let layout = makeLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }
    
    private func makeDataSource(_ collectionView: UICollectionView) -> NewsCollectionDataSource {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            
            return UICollectionViewCell()
        }
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            
            return section
        }
    }
}

struct NewsCollectionSection: IdentifiableSection {
    let identifier: AnyHashable
    
    let style: NewsCollectionSectionStyle
    let items: [CollectionSectionItem]
}

enum NewsCollectionSectionStyle: Hashable {
    case list
}

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

// MARK: - View -
struct NewsShortViewBindings: CellModelProtocol, Equatable {
    var identity: AnyHashable
    var equatable: AnyEquatable { AnyEquatable(self) }
    
    let image: AnyPublisher<UIImage?, Never>
    let title: String
    let description: String
    let date: String
    
    static func == (lhs: NewsShortViewBindings, rhs: NewsShortViewBindings) -> Bool {
        lhs.title == rhs.title
        && lhs.description == rhs.description
        && lhs.date == rhs.date
    }
}

final class NewsShortView: CommonInitView, CombineConfiguringView {
    private var iconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var dateLabel: UILabel!
    
    func configure(with model: NewsShortViewBindings) -> AnyCancellable {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        dateLabel.text = model.date
        
        return model.image
            .receive(on: DispatchQueue.main)
            .assign(to: \.iconImageView.image, on: self)
    }
    
    override func commonInit() {
        super.commonInit()
        
        setupUI()
    }
    
    private func setupUI() {
        
    }
}




// TODO: - Вынести в расширения/отдельные файлы -

extension Array: @retroactive Cancellable where Element == Cancellable {
    public func cancel() {
        forEach { $0.cancel() }
    }
}


// MARK: - Diffable sections&items
protocol IdentifiableSection: Hashable {
    associatedtype Identifier: Hashable
    associatedtype Item: Hashable
    
    var identifier: Identifier { get }
    var items: [Item] { get }
}

extension IdentifiableSection {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.items == rhs.items
    }
}

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
