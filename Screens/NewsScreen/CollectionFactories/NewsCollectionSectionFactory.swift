//
//  NewsCollectionSectionFactory.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


enum NewsCollectionSectionFactoryEvent {
    case showDetails(RemoteNews)
}

struct NewsCollectionSectionFactory {
    var onEvent: (NewsCollectionSectionFactoryEvent) -> () = { _ in }
    
    private let imageService: ImageServiceProtocol
    private let cellFactory: NewsCollectionCellFactory
    private let counter = Counter()
    
    init(imageService: ImageServiceProtocol, cellFactory: NewsCollectionCellFactory) {
        self.imageService = imageService
        self.cellFactory = cellFactory
    }
    
    func resetSections(_ news: [RemoteNews]) -> [NewsCollectionSection] {
        counter.reset()
        
        let items = news.map(makeNewsItem)
        let newsSection = NewsCollectionSection(
            identifier: "news_section:\(counter.next())",
            style: .list,
            items: items
        )
        
        return [newsSection]
    }
    
    private func makeNewsItem(_ news: RemoteNews) -> CollectionSectionItem {
        let bindings = makeNewsItemBindings(news)
        return cellFactory.news(bindings: bindings)
    }
    
    private func makeNewsItemBindings(_ remote: RemoteNews) -> NewsShortViewBindings {
        NewsShortViewBindings(
            identity: "position:_\(counter.next())_id:\(remote.id)",
            image: imageService.load(from: remote.titleImageUrl),
            title: remote.title ?? "-",
            description: remote.description ?? "-",
            date: remote.transformedDate?.toFormat(.ddmmmmyyyy) ?? "-",
            showDetail: { onEvent(.showDetails(remote)) }
        )
    }
}
