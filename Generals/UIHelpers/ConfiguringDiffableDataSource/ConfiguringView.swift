//
//  ConfiguringView.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit
import Combine


// MARK: - Any configuring -
protocol AnyCellViewProtocol {}


// MARK: - Configuring view -
protocol ConfiguringView: UIView {
    associatedtype Model: CellModelProtocol
    func configure(with model: Model)
}


// MARK: - Combine configuring view
protocol CombineConfiguringView: UIView {
    associatedtype Model: CellModelProtocol
    func configure(with model: Model) -> Cancellable
}
