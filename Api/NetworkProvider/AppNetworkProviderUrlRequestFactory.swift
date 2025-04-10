//
//  AppNetworkProviderUrlRequestFactory.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation


enum AppNetworkProviderUrlRequestFactory {
    //MARK: - Make url request
    static func makeURLRequest(for target: NetworkTarget) -> Result<URLRequest, Error> {
        let url = target.baseUrl.appendingPathComponent(target.path)
        return makeRequest(url: url, method: target.method)
    }
    
    static func makeRequest(url: URL, method: String) -> Result<URLRequest, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return .success(request)
    }
}
