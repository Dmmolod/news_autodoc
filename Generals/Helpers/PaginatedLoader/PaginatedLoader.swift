//
//  PaginatedLoader.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation
import Combine


public typealias Page = Int
public typealias Force = Bool

public final class PaginatedLoader<Model> {
    public typealias RequestBuilder = (Page, Force) -> AnyPublisher<[Model], Error>
    public typealias RequestBuilderWithoutForce = (Page) -> AnyPublisher<[Model], Error>
    
    private let requestBuilder: RequestBuilder
    
    public var errorHander: (Error) -> Void = { _ in }
    
    public let stateSubject = CurrentValueSubject<Paginated<Model>, Never>(.loaded([]))
    
    private var currentPage: Page
    
    private let initialPage: Page
    
    private var allLoaded: Bool = false
    
    private var requestCancellable: AnyCancellable?
    
    public init(initialPage: Page = 1, requestBuilder: @escaping RequestBuilder) {
        self.initialPage = initialPage
        self.currentPage = initialPage
        self.requestBuilder = requestBuilder
    }
    
    public convenience init(initialPage: Page = 1, requestBuilder: @escaping RequestBuilderWithoutForce) {
        self.init(initialPage: initialPage, requestBuilder: { page, _ in requestBuilder(page) })
    }
    
    public func reset() {
        currentPage = initialPage
        stateSubject.send(.loaded([]))
        allLoaded = false
    }
    
    public func refresh(force: Bool = false) {
        guard force || !stateSubject.value.isLoading else {
            return
        }
        
        allLoaded = false
        currentPage = initialPage
        
        stateSubject.send(Paginated.loading)
        requestCancellable?.cancel()
        
        requestCancellable = requestBuilder(initialPage, force)
            .flatMap({ [weak self] models in
                self?.currentPage += 1
                return Just(models)
            })
            .map(Paginated.loaded)
            .sink(receiveCompletion: { [weak self] complition in
                if case let .failure(error) = complition {
                    self?.errorHander(error)
                }
            }, receiveValue: { [weak self] in
                self?.stateSubject.send($0)
            })
    }
    
    public func loadMore() {
        let currentState = stateSubject.value
        
        guard !currentState.isLoading, !allLoaded else {
            return
        }
        
        guard !currentState.items.isEmpty else {
            refresh()
            return
        }

        stateSubject.send(Paginated.loadMore(currentState.items))
        requestCancellable?.cancel()
        
        requestCancellable = requestBuilder(currentPage, false)
            .flatMap({ [weak self] in
                self?.allLoaded = $0.isEmpty
                self?.currentPage += 1
                return Just($0)
            })
            .map(currentState.update)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorHander(error)
                }
            }, receiveValue: { [weak self] in
                self?.stateSubject.send($0)
            })
    }
}
