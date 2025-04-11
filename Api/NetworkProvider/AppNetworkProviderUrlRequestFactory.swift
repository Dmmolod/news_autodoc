//
//  AppNetworkProviderUrlRequestFactory.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation


enum AppNetworkProviderUrlRequestFactory {
    //MARK: - Make url request
    /// Базовая генерация запроса из цели
    /// - Parameter target: объект с описанием цели запроса
    /// - Returns: запрос или ошибку
    static func makeURLRequest(for target: NetworkTarget) -> Result<URLRequest, Error> {
        let url = target.baseUrl.appendingPathComponent(target.path)
        return makeRequest(url: url, method: target.method)
    }
    
    /// Базовая генерация запроса из URL и метода
    /// - Parameters:
    ///   - url: url по которому будет запрос
    ///   - method: метод запроса
    /// - Returns: запрос или ошибку
    static func makeRequest(url: URL, method: String) -> Result<URLRequest, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return .success(request)
    }
}
