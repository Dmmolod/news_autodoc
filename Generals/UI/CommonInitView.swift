//
//  CommonInitView.swift
//  NewsAutodoc
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import UIKit


/// Для большего контроля в будущем, рекомендуется наследоваться от кастомного объекта
class CommonInitView: UIView {
    // MARK: - Initialization -
    init() {
        super.init(frame: .zero)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    // MARK: - Internal methods -
    /// Переопределять этот метод, вместо описания инициализатора
    func commonInit() {
        
    }
}
