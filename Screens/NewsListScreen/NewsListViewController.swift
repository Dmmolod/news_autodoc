//
//  NewsViewController.swift
//  NewsAutodoc
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import UIKit
import Combine


protocol NewsListViewControllerBindings {
    var newsSectionsPublisher: AnyPublisher<[NewsListCollectionSection], Never> { get }
    func willScrollToEnd()
}

final class NewsListViewController: CommonInitViewController {
    private var collectionView: UICollectionView!
    private var dataSource: NewsCollectionDataSource!
    
    func bind(to bindings: NewsListViewControllerBindings) -> Cancellable {
        return [
            bindings.newsSectionsPublisher
                .bind(using: dataSource),
            
            collectionView.willScrollToEndPublisher
                .dropFirst(1)
                .sink(receiveValue: bindings.willScrollToEnd)
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
        view.backgroundColor = .white
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 4
        
        let titleLabel = UILabel()
        titleLabel.text = "Новости"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        
        let titleStack = UIStackView(arrangedSubviews: [titleLabel])
        titleStack.isLayoutMarginsRelativeArrangement = true
        titleStack.layoutMargins.left = 16
        
        vStack.addArrangedSubview(titleStack)
        vStack.addArrangedSubview(collectionView)
        
        view.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

private typealias NewsCollectionDataSource = ConfiguringDiffableDataSource<NewsListCollectionSection>

// MARK: - View controller factory methods -
private extension NewsListViewController {
    private func makeCollectionView() -> UICollectionView {
        let layout = makeLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
        return collectionView
    }
    
    private func makeDataSource(_ collectionView: UICollectionView) -> NewsCollectionDataSource {
        return .makeDataSource(collectionView: collectionView)
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            
            return section
        }
    }
}

// MARK: - News section -
struct NewsListCollectionSection: IdentifiableSection {
    let identifier: AnyHashable
    
    let style: NewsListCollectionSectionStyle
    let items: [CollectionSectionItem]
}

enum NewsListCollectionSectionStyle: Hashable {
    case list
}
