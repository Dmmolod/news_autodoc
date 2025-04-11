//
//  AppDependenciesFactory.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


enum AppDependenciesFactory {
    static func buildAppDependeincies(config: AppConfiguration) -> AppDependencies {
        let networkProvider = AppNetworkProvider()
        let apiClient = AppApiClient(baseUrl: config.baseUrl, provider: networkProvider)
        let services = AppServices(apiClient: apiClient, imageBaseUrl: config.imageBaseUrl)
        let appDependencies = AppDependencies(services: services)
        
        return appDependencies
    }
}
