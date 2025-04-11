//
//  NewsFlowFactory.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit


enum NewsFlowFactory {
    static func buildNewsListScreen(
        deps: NewsFlowDependencies,
        onScreenEvent: @escaping (NewsListScreenEvent) -> ()
    ) -> UIViewController {
        let cellRegistrator = CollectionCellRegistrator()
        let cellFactory = NewsListCollectionCellFactory(cellRegistrator: cellRegistrator)
        let sectionFactory = NewsListCollectionSectionFactory(imageService: deps.imageService, cellFactory: cellFactory)
        
        let viewModel = NewsListViewModel(newsService: deps.newsService, sectionFactory: sectionFactory)
        viewModel.onScreenEvent = onScreenEvent
        
        let viewController = NewsListViewController()
        viewController.subscription = { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        return viewController
    }
}
