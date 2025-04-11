//
//  UICollectionView+dequeue.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit


extension UICollectionView {
    func dequeue<Cell: UICollectionViewCell>(at indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: Cell.reuseId, for: indexPath) as! Cell
    }
}

extension UICollectionReusableView {
    static var reuseId: String { String(describing: self) }
}
