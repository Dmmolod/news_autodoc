//
//  CommonInitViewController.swift
//  NewsAutodoc
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import UIKit


/// Для большего контроля в будущем, рекомендуется наследоваться от кастомного объекта
class CommonInitViewController: UIViewController {
    // MARK: - Initialization -
    init() {
        super.init(nibName: nil, bundle: nil)
        
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    // MARK: - Internal methods -
    /// Переопределить вместо описания инициализатора
    func commonInit() {
        
    }
}
