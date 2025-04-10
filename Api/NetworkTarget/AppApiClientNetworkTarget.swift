//
//  AppApiClientNetworkTarget.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation



struct AppApiClientNetworkTarget: NetworkTarget {
    let baseUrl: URL
    let path: String
    let method: String
}
