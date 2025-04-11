//
//  AppFlowHelpers.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit


extension AppFlow {
    
    static func animateWindowRootChanges(
        _ window: UIWindow,
        duration: CGFloat = 0.2,
        completion: @escaping () -> () = {}
    ) {
        UIView.transition(
            with: window,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: { _ in completion() }
        )
    }
    
}
