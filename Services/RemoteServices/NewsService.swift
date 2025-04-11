//
//  NewsService.swift
//  NewsAutodoc
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation
import Combine


protocol NewsService {
    func news(page: Int, count: Int) -> AnyPublisher<[RemoteNews], any Error>
}

struct AutodocNewsService: NewsService {
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func news(page: Int, count: Int) -> AnyPublisher<[RemoteNews], any Error> {
        apiClient.requestModel(.News.news(page: page, count: count))
            .map({ (response: RemoteNewsResponse) in response.news })
            .eraseToAnyPublisher()
    }
}
