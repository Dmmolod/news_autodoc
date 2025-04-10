//
//  NewsApiEndpoints.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation


extension ApiEndpoint {
    enum News {}
}

extension ApiEndpoint.News {
    static func news(page: Int, count: Int) -> ApiEndpoint {
        ApiEndpoint(path: "/news/\(page)/\(count)")
    }
}
