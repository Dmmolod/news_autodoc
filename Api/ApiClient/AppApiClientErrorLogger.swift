//
//  AppApiClientErrorLogger.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


enum AppApiClientErrorLogger {
    static func log(_ error: Error) {
        if let apiError = error as? AppApiClientError {
            print("[AppApiClientErrorLogger] ❌ \(apiError)")
            
            switch apiError {
            case .failParseJson(let parseError):
                print("[AppApiClientErrorLogger] ❌ Parse JSON failed: \(parseError.localizedDescription)")

            case .responseError(let responseError):
                print("[AppApiClientErrorLogger] ❌ Response Error:")
                if let code = responseError.statusCode {
                    print("[AppApiClientErrorLogger] - Status Code: \(code)")
                }
                
                if let body = responseError.body,
                   let bodyString = String(data: body, encoding: .utf8) {
                    print("[AppApiClientErrorLogger] - Body JSON: \(bodyString)")
                }
                
            case .systemError(let sysError):
                print("[AppApiClientErrorLogger] ❌ System Error: \(sysError.localizedDescription)")
            }

        } else {
            print("[AppApiClientErrorLogger] ❌ Unknown Error: \(error.localizedDescription)")
        }
    }
}
