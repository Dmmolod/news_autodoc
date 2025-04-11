//
//  AppFlow.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit


enum AppFlow {
    
    static func setAppFlow(
        in window: UIWindow,
        appDeps: AppDependencies
    ) {
        let navigationController = NavigationController()
        window.rootViewController = navigationController
        animateWindowRootChanges(window)
        
        NewsFlow.pushNewsList(in: navigationController, deps: appDeps)
    }
    
}
