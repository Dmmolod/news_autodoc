//
//  ApiClient.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation
import Combine


protocol ApiClient {
    /// Базовый запрос
    func request(_ endpoint: ApiEndpoint) -> AnyPublisher<Data, any Error>
    
    /// Запрос возвращающий модель
    func requestModel<Model: Decodable>(_ endpoint: ApiEndpoint) -> AnyPublisher<Model, any Error>
}
