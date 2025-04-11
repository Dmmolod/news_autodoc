//
//  AppDependencies.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


protocol AppDependenciesProtocol: ImageLoadingDependencies,
                                  NewsFlowDependencies {}

struct AppDependencies: AppDependenciesProtocol {
    
    private let services: Services
    
    init(services: Services) {
        self.services = services
    }
}

extension AppDependencies: ImageLoadingDependencies {
    var imageService: ImageServiceProtocol { services.imageService }
}

extension AppDependencies: NewsFlowDependencies {
    var newsService: NewsService { services.newsService }
}
