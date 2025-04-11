//
//  AppDelegate.swift
//  NewsAutodoc
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
}

// MARK: - Life cycle -
extension AppDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        window.rootViewController = buildNewsScreen()
        window.makeKeyAndVisible()
        
        return true
    }
    
    func buildNewsScreen() -> UIViewController {
        let networkProvider = AppNetworkProvider()
        let apiClient = AppApiClient(baseUrl: config.baseUrl, provider: networkProvider)
        
        let newsService = AutodocNewsService(apiClient: apiClient)
        let imageService = UrlSessionImageService(baseUrl: config.imageBaseUrl)
        
        let cellRegistrator = CollectionCellRegistrator()
        let collectionCellFactory = NewsCollectionCellFactory(cellRegistrator: cellRegistrator)
        let collectionFactory = NewsCollectionSectionFactory(imageService: imageService, cellFactory: collectionCellFactory)
        
        let viewModel = NewsViewModel(
            newsService: newsService,
            sectionFactory: collectionFactory
        )
        
        let viewController = NewsViewController()
        viewController.subscription = { [unowned viewController] in
            viewController.bind(to: viewModel)
        }
        
        viewModel.flowAction = { flowAction in
            switch flowAction {
            case let .detailNewsWebView(url):
                UIApplication.shared.open(url)
            }
        }
        
        return viewController
    }
}


let config: AppConfiguration = {
#if APPSTORE
    return AppConfigurationAppStore()
#endif
}()

protocol AppConfiguration {
    var baseUrl: URL { get }
    var imageBaseUrl: URL { get }
}

struct AppConfigurationAppStore: AppConfiguration {
    var baseUrl: URL { URL(string: "https://webapi.autodoc.ru/api")! }
    var imageBaseUrl: URL { URL(string: "https://file.autodoc.ru")! }
}
