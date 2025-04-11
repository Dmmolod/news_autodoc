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
    
    /// Инициализация клиента
    /// - Parameters:
    ///   - baseUrl: базовый путь для обращений на сервер
    ///   - decoder: декодер, который будет применяться для преобразования ответов в модель
    ///   - provider: провайдер, который совершает запросы в сеть
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
    /// Базовый запрос
    /// - Parameter endpoint: конечная точка запроса
    /// - Returns: Ответ с сервера в виде Data
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
    
    /// Запрос возвращающий модель
    /// - Parameter endpoint: конечная точка запроса
    /// - Returns: декодированная модель данных
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
    /// - Parameter error: Ошибка которая пришла в ответ
    /// - Returns: Преобразованная ошибка в модель *AppApiClientError*
    private func transformRequestError(_ error: Error) -> Error {
        if let networkResponseError = error as? AppNetworkProviderResponseError {
            return AppApiClientError.responseError(networkResponseError)
        } else {
            return AppApiClientError.systemError(error)
        }
    }
    
    /// Попытка парсинга ответа, в случае ошибки вернет объект AppApiClientError
    /// - Parameter data: данные, которые пришли в ответ
    /// - Returns: в случае успеша - ожидаемая модель, в случае провала - ошибку типа *AppApiClientError*
    private func tryToDecodeRequest<Model: Decodable>(_ data: Data) throws -> Model {
        do {
            return try decoder.decode(Model.self, from: data)
        } catch {
            throw AppApiClientError.failParseJson(error)
        }
    }
}
