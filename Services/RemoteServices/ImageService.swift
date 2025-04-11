//
//  ImageService.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit
import Combine


public protocol ImageServiceProtocol {
    func load(from url: String?) -> AnyPublisher<UIImage?, Never>
}

final class UrlSessionImageService: ImageServiceProtocol {
    private let baseUrl: URL
    private let cache: NSCache<NSString, UIImage>
    private let session: URLSession
    
    public init(
        baseUrl: URL,
        session: URLSession = .shared,
        cache: NSCache<NSString, UIImage> = .init()
    ) {
        self.baseUrl = baseUrl
        self.session = session
        self.cache = cache
    }
    
    func load(from url: String?) -> AnyPublisher<UIImage?, Never> {
        guard let url = resolve(url: url) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        let cacheKey = (url.absoluteString + "_2.0") as NSString
        
        return Deferred { [weak self] () -> AnyPublisher<UIImage?, Never> in
            if let cachedImage = self?.cache.object(forKey: cacheKey) as? UIImage {
                return Just(cachedImage).eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { data, response in
                    guard let image = UIImage(data: data) else {
                        return nil
                    }
                    
                    return image.resizedToFit()
                }
                .handleEvents(receiveOutput: { [weak self] image in
                    guard let image else {
                        return
                    }
                    // Сохраняем картинку в кеш
                    self?.cache.setObject(image, forKey: cacheKey)
                })
                .catch({ _ in Just(nil) })
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    private func resolve(url: String?) -> URL? {
        guard let urlString = url else {
            return nil
        }
        
        if let localURL = URL(string: urlString), localURL.isFileURL {
            return localURL
        }
        
        if !urlString.hasPrefix("http") {
            return baseUrl.appendingPathComponent(urlString.removingPercentEncoding ?? "")
        }
        
        return URL(string: urlString)
    }
}

private extension UIImage {
    func resizedToFit(maxDimension: CGFloat = 1080) -> UIImage? {
        let maxSide = max(size.width, size.height)
        guard maxSide > maxDimension else {
            return self
        }

        let scale = maxDimension / maxSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
