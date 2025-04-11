//
//  UICollectionView+willScrollToEnd.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit
import Combine


extension UICollectionView {
    var willScrollToEndPublisher: AnyPublisher<Void, Never> {
        publisher(for: \.contentOffset)
            .map({ [weak self] offset in
                guard let self else {
                    return false
                }
                
                let maxY = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
                let bottomOffset = offset.y + self.bounds.height
                return (maxY - bottomOffset) <= 300
            })
            .removeDuplicates()
            .filter({ $0 })
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .map({ _ in })
            .eraseToAnyPublisher()
    }
}
