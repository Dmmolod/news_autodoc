//
//  CollectionCellWrapper.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit
import Combine


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
