//
//  CellRegistrator.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit


// MARK: - Registration cells -

/// Протокол, описывающий объект, ответственный за регистрацию ячеек в `UICollectionView`.
protocol CollectionCellRegistratorProtocol {
    /// Множество идентификаторов уже зарегистрированных ячеек.
    var registeredCells: Set<AnyHashable> { get set }
    
    /// Метод регистрации ячейки в `UICollectionView`.
    ///
    /// - Parameters:
    ///   - cellType: Тип ячейки, которую необходимо зарегистрировать.
    ///   - collectionView: Коллекция, в которую производится регистрация.
    func registerCell<Cell: UICollectionViewCell>(_ cellType: Cell.Type, in collectionView: UICollectionView)
}

/// Класс, реализующий регистрацию ячеек в `UICollectionView`,
/// с защитой от повторной регистрации одного и того же типа.
final class CollectionCellRegistrator {
    /// Набор идентификаторов уже зарегистрированных ячеек.
    var registeredCells: Set<AnyHashable> = []
    
    /// Инициализация регистратора.
    init() {}
    
    /// Регистрирует ячейку в `UICollectionView`, если она ещё не была зарегистрирована.
    ///
    /// - Parameters:
    ///   - cellType: Тип ячейки для регистрации.
    ///   - collectionView: Коллекция, в которую производится регистрация.
    func registerCell<Cell: UICollectionViewCell>(_ cellType: Cell.Type, in collectionView: UICollectionView) {
        guard !registeredCells.contains(cellType.reuseId) else {
            return
        }
        
        collectionView.register(cellType, forCellWithReuseIdentifier: cellType.reuseId)
        registeredCells.insert(cellType.reuseId)
    }
}
