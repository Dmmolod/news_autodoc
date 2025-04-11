//
//  NewsViewModel.swift
//  NewsAutodoc
//
//  Created by Дмитрий Молодецкий on 10.04.2025.
//

import Foundation
import Combine


final class NewsListViewModel: ObservableObject {
    var onScreenEvent: (NewsListScreenEvent) -> () = { _ in }
    
    private let newsService: NewsService
    private var sectionFactory: NewsListCollectionSectionFactory
    private var paginatedLoader: PaginatedLoader<RemoteNews>!
    
    @Published private var sections: [NewsListCollectionSection] = []
    
    private var cancellables: [AnyCancellable] = []
    
    init(
        newsService: NewsService,
        sectionFactory: NewsListCollectionSectionFactory
    ) {
        self.newsService = newsService
        self.sectionFactory = sectionFactory
        
        self.paginatedLoader = PaginatedLoader { page in
            newsService.news(page: page, count: 15)
        }
        
        observePaginateState()
        observeCollectionsEvents()
        
        loadMoreNews()
    }
    
    // MARK: - Common control methods
    func loadMoreNews() {
        paginatedLoader.loadMore()
    }
}

// MARK: - Private observe helpers -
extension NewsListViewModel {
    private func observePaginateState() {
        paginatedLoader.stateSubject
            .filter({ !$0.isLoading })
            .compactMap({ [weak self] state in self?.sectionFactory.resetSections(state.items) })
            .removeDuplicates()
            .assign(to: \.sections, on: self)
            .store(in: &cancellables)
    }
    
    private func observeCollectionsEvents() {
        sectionFactory.onEvent = { [weak self] event in
            switch event {
            case let .showDetails(news):
                self?.showDetailWebView(for: news)
            }
        }
    }
}

// MARK: - Private handle event helpers -
extension NewsListViewModel {
    private func showDetailWebView(for news: RemoteNews) {
        guard let urlString = news.fullUrl,
              let url = URL(string: urlString) else {
            return
        }
        
        onScreenEvent(.detailNewsWebView(url))
    }
}

// MARK: - Bindings for view controller
extension NewsListViewModel: NewsListViewControllerBindings {
    var newsSectionsPublisher: AnyPublisher<[NewsListCollectionSection], Never> {
        $sections.eraseToAnyPublisher()
    }
    
    func willScrollToEnd() {
        loadMoreNews()
    }
}
