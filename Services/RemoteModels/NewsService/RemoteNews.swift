//
//  RemoteNews.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


struct RemoteNewsResponse: Decodable {
    let news: [RemoteNews]
}

struct RemoteNews: Decodable {
    let id: Int
    let title: String?
    let description: String?
    let publishedDate: String?
    let url: String?
    let fullUrl: String?
    let titleImageUrl: String?
    let categoryType: String?
    
    var transformedDate: Date? {
        publishedDate?.toDate(with: .iso8601)
    }
}
