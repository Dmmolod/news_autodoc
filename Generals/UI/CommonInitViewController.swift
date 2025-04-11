//
//  CommonInitViewController.swift
//  NewsAutodoc
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import UIKit
import Combine


/// Для большего контроля в будущем, рекомендуется наследоваться от кастомного объекта
class CommonInitViewController: UIViewController {
    var subscription: () -> Cancellable? = { nil }
    var cancellables: Cancellable? = nil
    
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
    
    // MARK: - Override methods -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cancellables = subscription()
    }
    
    // MARK: - Internal methods -
    /// Переопределить вместо описания инициализатора
    func commonInit() {
        
    }
}
