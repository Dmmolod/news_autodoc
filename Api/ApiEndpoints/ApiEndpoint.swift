//
//  ApiEndpoint.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation

struct ApiEndpoint {
    let method: ApiMethod
    let path: String
    
    /// Default: - method: .get
    init(
        method: ApiMethod = .get,
        path: String
    ) {
        self.method = method
        self.path = path
    }
}

extension ApiEndpoint {
    enum ApiMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
    }
}
