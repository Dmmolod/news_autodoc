//
//  Services.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation

protocol Services {
    var newsService: NewsService { get }
    var imageService: ImageServiceProtocol { get }
}

struct AppServices: Services {
    let newsService: NewsService
    let imageService: ImageServiceProtocol
    
    init(apiClient: ApiClient, imageBaseUrl: URL) {
        self.newsService = AutodocNewsService(apiClient: apiClient)
        self.imageService = UrlSessionImageService(baseUrl: imageBaseUrl)
    }
}
