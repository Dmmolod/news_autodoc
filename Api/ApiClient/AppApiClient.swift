//
//  AppApiClient.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation
import Combine


struct AppApiClient: ApiClient {
    private let baseUrl: URL
    private let decoder: JSONDecoder
    private let provider: NetworkProvider
    
    init(
        baseUrl: URL,
        decoder: JSONDecoder = JSONDecoder(),
        provider: NetworkProvider
    ) {
        self.baseUrl = baseUrl
        self.decoder = decoder
        self.provider = provider
    }
    
    // MARK: - Internal methods -
    func request(_ endpoint: ApiEndpoint) -> AnyPublisher<Data, any Error> {
        let target = AppApiClientNetworkTarget(
            baseUrl: baseUrl,
            path: endpoint.path,
            method: endpoint.method.rawValue
        )
        
        return provider.request(target)
            .mapError(transformRequestError)
            .eraseToAnyPublisher()
    }
    
    func requestModel<Model: Decodable>(_ endpoint: ApiEndpoint) -> AnyPublisher<Model, any Error> {
        request(endpoint)
            .tryMap(tryToDecodeRequest)
            .mapError({ error in
                AppApiClientErrorLogger.log(error)
                return error
            })
            .eraseToAnyPublisher()
    }
}


// MARK: - Private helpers methods -
extension AppApiClient {
    /// Преобразует ошибку при выполнении запроса либо системную ошибку, либо в ошибку связанную с ответом
    private func transformRequestError(_ error: Error) -> Error {
        if let networkResponseError = error as? AppNetworkProviderResponseError {
            return AppApiClientError.responseError(networkResponseError)
        } else {
            return AppApiClientError.systemError(error)
        }
    }
    
    /// Попытка парсинга ответа, в случае ошибки вернет объект AppApiClientError
    private func tryToDecodeRequest<Model: Decodable>(_ data: Data) throws -> Model {
        do {
            return try decoder.decode(Model.self, from: data)
        } catch {
            throw AppApiClientError.failParseJson(error)
        }
    }
}
