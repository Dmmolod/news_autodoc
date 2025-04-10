//
//  NetworkTarger.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation


protocol NetworkTarget {
    var baseUrl: URL { get }
    var path: String { get }
    var method: String { get }
}
