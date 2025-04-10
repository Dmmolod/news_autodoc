//
//  AppApiClientError.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation


enum AppApiClientError: Error, LocalizedError {
    case failParseJson(Error)
    case responseError(AppNetworkProviderResponseError)
    case systemError(Error)
    
    var rawError: any Error {
        switch self {
        case .failParseJson(let error), .systemError(let error):
            return error
        case .responseError(let error):
            return error
        }
    }
    
    var errorDescription: String? {
        return rawError.localizedDescription
    }
}
