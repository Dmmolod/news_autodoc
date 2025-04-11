//
//  NewsFlowDependencies.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


protocol NewsFlowDependencies: ImageLoadingDependencies {
    var newsService: NewsService { get }
}
