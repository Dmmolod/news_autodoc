//
//  NewsFlow.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit


extension AppFlow {
    enum NewsFlow {}
}

extension AppFlow.NewsFlow {
    
    static func pushNewsList(
        in navigationController: UINavigationController,
        deps: NewsFlowDependencies
    ) {
        let viewController = NewsFlowFactory.buildNewsListScreen(
            deps: deps,
            onScreenEvent: { event in
                switch event {
                case .detailNewsWebView(let url):
                    UIApplication.shared.open(url)
                }
            }
        )
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
