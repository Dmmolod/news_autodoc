//
//  CollectionCellWrapper.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit
import Combine


// MARK: - CollectionCellWrapper

/// Протокол для обёртки ячеек коллекции, который позволяет привязывать вьюшку к ячейке.
///
/// Протокол требует, чтобы ячейка содержала обёрнутую вьюшку, которая должна быть
/// реализована как `UIView`. Таким образом, можно работать с ячейками коллекции,
/// скрывая детали реализации конкретной ячейки.
public protocol CollectionCellWrapper: UICollectionViewCell {
    /// Тип вьюшки, которая оборачивается внутри ячейки.
    associatedtype View: UIView
    
    /// Обёрнутая вьюшка, доступная для настройки.
    var wrappedView: View { get }
}

// MARK: - CancellableCollectionCellWrapper

/// Протокол для обёртки ячеек коллекции с поддержкой отмены подписок.
///
/// Этот протокол расширяет `CollectionCellWrapper` и добавляет поддержку отслеживания
/// и отмены подписок, которые были сделаны в процессе конфигурации ячейки.
public protocol CancellableCollectionCellWrapper: CollectionCellWrapper {
    /// Массив подписок, которые могут быть отменены при переиспользовании ячейки.
    var cancellabels: [AnyCancellable] { get set }
}

// MARK: - WrappedCollectionViewCell

/// Базовая реализация ячейки коллекции с обёрнутой вьюшкой.
///
/// Этот класс реализует протокол `CollectionCellWrapper` и предоставляет механизм
/// для работы с обёрнутыми вьюшками внутри ячейки.
class WrappedCollectionViewCell<WrappedView: UIView>: UICollectionViewCell, CollectionCellWrapper {
    /// Обёрнутая вьюшка, которая будет добавлена в ячейку.
    let wrappedView = WrappedView()
    
    /// Инициализатор для создания ячейки с нулевым фреймом.
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    /// Инициализатор для создания ячейки с заданным фреймом.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    /// Требуемый инициализатор для использования с `Interface Builder`.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    /// Настройка UI: добавление `wrappedView` в контентную вьюшку ячейки.
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

// MARK: - CancellableWrappedCollectionCell

/// Ячейка коллекции с поддержкой отмены подписок, использующая `WrappedCollectionViewCell`.
///
/// Этот класс реализует `CancellableCollectionCellWrapper`, добавляя возможность
/// отслеживания подписок и их отмены при переиспользовании ячейки.
class CancellableWrappedCollectionCell<WrappedView: UIView>: WrappedCollectionViewCell<WrappedView>, CancellableCollectionCellWrapper {
    
    /// Массив подписок, которые могут быть отменены при переиспользовании ячейки.
    var cancellabels: [AnyCancellable] = []
    
    /// Подготовка ячейки к переиспользованию: отмена всех подписок.
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellabels.forEach({ $0.cancel() })
        cancellabels = []
    }
}
