//
//  NetworkProvider.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation
import Combine


protocol NetworkProvider {
    func request(_ target: NetworkTarget) -> AnyPublisher<Data, any Error>
}
