//
//  UICollectionView+dequeue.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit


// MARK: - UICollectionView dequeue extension

/// Расширение для `UICollectionView`, добавляющее метод для удобного
/// извлечения ячейки с использованием её типа.
///
/// Этот метод позволяет избежать использования строковых идентификаторов для ячеек,
/// что делает код чище и безопаснее, а также уменьшает шанс ошибок с типами.
///
/// - Parameter indexPath: Индекс пути для извлечения ячейки.
/// - Returns: Ячейка типа `Cell`, соответствующая указанному типу.
extension UICollectionView {
    func dequeue<Cell: UICollectionViewCell>(at indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: Cell.reuseId, for: indexPath) as! Cell
    }
}

extension UICollectionReusableView {
    static var reuseId: String { String(describing: self) }
}
