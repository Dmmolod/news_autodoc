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
    
    private func send(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                let response = response as? HTTPURLResponse
                let statusCode = response?.statusCode
                
                if let statusCode, (200...299).contains(statusCode) {
                    
                    return data
                } else {
                    let body = data.isEmpty ? nil : data
                    throw AppNetworkProviderResponseError(statusCode: statusCode, body: body)
                }
            }
            .eraseToAnyPublisher()
    }
}
