//
//  AppNetworkProviderResponseError.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation


struct AppNetworkProviderResponseError: LocalizedError {
    let statusCode: Int?
    let body: Data?
    
    var errorDescription: String? {
        let serialization: Any? = body.flatMap({ data in try? JSONSerialization.jsonObject(with: data) })
        let bodyLine = serialization.flatMap({ body in "\n- body: \(body)" }) ?? ""
        let statusCodeLine = statusCode.flatMap({ code in "\n- status code: \(code)" }) ?? ""
        
        return "Network Api Error:\(statusCodeLine)\(bodyLine)"
    }
}
