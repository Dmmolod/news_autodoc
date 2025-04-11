//
//  AppNetworkProvider.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation
import Combine


struct AppNetworkProvider: NetworkProvider {
    func request(_ target: NetworkTarget) -> AnyPublisher<Data, any Error> {
        AppNetworkProviderUrlRequestFactory.makeURLRequest(for: target)
            .publisher
            .flatMap(send)
            .eraseToAnyPublisher()
    }
    
    /// Отправка запроса в сеть, успешные запросы с кодами - 200...299
    /// - Parameter request: сам запрос
    /// - Returns: возвращает паблишера с данными ответа или ошибкой
    private func send(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .handleEvents(
                receiveSubscription: { _ in
                    NetworkLogger.logRequest(request)
                },
                receiveOutput: { output in
                    NetworkLogger.logResponse(output.response, data: output.data, error: nil)
                },
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        NetworkLogger.logResponse(nil, data: nil, error: error)
                    }
                }
            )
            .tryMap { data, response in
                let response = response as? HTTPURLResponse
                let statusCode = response?.statusCode
                
                if let statusCode, (200...299).contains(statusCode) {
                    
                    return data
                } else {
                    let body = data.isEmpty ? nil : data
                    let error = AppNetworkProviderResponseError(statusCode: statusCode, body: body)
                    NetworkLogger.logResponse(response, data: data, error: error)
                    
                    throw error
                }
            }
            .eraseToAnyPublisher()
    }
}
