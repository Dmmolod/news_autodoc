//
//  ConfiguringView.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit
import Combine


// MARK: - Any configuring -

/// Базовый маркерный протокол для всех вьюх, которые можно использовать в ячейках коллекции.
///
/// Не содержит требований и служит для универсального обращения
/// с вьюшками без знания конкретного типа и модели.
protocol AnyCellViewProtocol {}


// MARK: - Configuring view -

/// Протокол для `UIView`, поддерживающих конфигурацию через модель данных.
///
/// Используется для построения ячеек с конкретной моделью.
/// Подходит для обычной (не реактивной) конфигурации.
///
/// Пример:
/// ```swift
/// struct MyModel: CellModelProtocol { ... }
///
/// final class MyView: UIView, ConfiguringView {
///     func configure(with model: MyModel) {
///         // Настройка UI
///     }
/// }
/// ```
protocol ConfiguringView: UIView {
    /// Тип модели, с которой работает вью.
    associatedtype Model: CellModelProtocol
    
    
    /// Метод конфигурации вью с моделью.
    ///
    /// - Parameter model: Модель, содержащая данные для отображения.
    func configure(with model: Model)
}


// MARK: - Combine configuring view

/// Протокол для `UIView`, поддерживающих конфигурацию через модель с возвратом `Cancellable`.
///
/// Используется в реактивных сценариях, например с Combine, когда конфигурация
/// возвращает подписку, которую нужно сохранить.
///
/// Подходит для вьюшек, в которых происходят подписки на `Publisher`-ы
/// и их нужно отменять при переиспользовании ячеек.
///
/// Пример:
/// ```swift
/// struct MyModel: CellModelProtocol { let title: AnyPublisher<String, Never> }
///
/// final class MyReactiveView: UIView, CombineConfiguringView {
///     func configure(with model: MyModel) -> Cancellable {
///         return model.title
///             .assign(to: \.label.text, on: self)
///     }
/// }
/// ```
protocol CombineConfiguringView: UIView {
    /// Тип модели, с которой работает вью.
    associatedtype Model: CellModelProtocol
    
    /// Метод конфигурации вью с моделью, возвращающий подписку для отмены.
    ///
    /// - Parameter model: Модель, содержащая данные для отображения.
    /// - Returns: Объект `Cancellable`, который можно отменить при переиспользовании ячейки.
    func configure(with model: Model) -> Cancellable
}
