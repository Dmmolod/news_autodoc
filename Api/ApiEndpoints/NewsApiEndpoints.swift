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
    /// Запрос списка новостей
    /// - Parameters:
    ///   - page: номер запрашиваемой страницы
    ///   - count: количество результатов в ответе
    /// - Returns: Конечную точку запроса
    static func news(page: Int, count: Int) -> ApiEndpoint {
        ApiEndpoint(path: "/news/\(page)/\(count)")
    }
}
