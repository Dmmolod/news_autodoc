//
//  NetworkLogger.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


enum NetworkLogLevel {
    case none, error, info, verbose
}

final class NetworkLogger {
    static var logLevel: NetworkLogLevel = .verbose

    static func logRequest(_ request: URLRequest) {
        guard logLevel == .info || logLevel == .verbose else { return }

        var log = "\n[NetworkLogger] --- 🚀 [REQUEST] ---\n"
        log += "[NetworkLogger] \(request.httpMethod ?? "NO METHOD") \(request.url?.absoluteString ?? "NO URL")\n"

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            log += "[NetworkLogger] Request Headers: \(headers)\n"
        }

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8),
           !bodyString.isEmpty {
            log += "[NetworkLogger] Body: \(bodyString)\n"
        }

        log += "[NetworkLogger] ----------------------\n"
        print(log)
    }

    static func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        guard logLevel != .none else { return }

        var log = "\n[NetworkLogger] --- 📥 [RESPONSE] ---\n"

        if let error = error {
            if logLevel == .error || logLevel == .verbose {
                log += "[NetworkLogger] ❌ Error: \(error.localizedDescription)\n"
            }
        } else if logLevel == .verbose, let data = data {
            let pretty = String(data: data, encoding: .utf8)
            log += "\n[NetworkLogger] Body:\n\(pretty ?? "-")\n"
        }

        log += "[NetworkLogger] ----------------------\n"
        print(log)
    }
}
