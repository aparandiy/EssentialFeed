//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 02.01.2024.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let curentDate: () -> Date
    
    public typealias SaveResult = Error?
    
    public init(store: FeedStore, curentDate: @escaping () -> Date) {
        self.store = store
        self.curentDate = curentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
    
    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> ()) {
        store.insert(feed.toLocal(), timestamp: curentDate(), completion: { [weak self] error in
            guard self != nil else { return }
            completion(error)
        })
    }
    
    public func load(completion: @escaping (Error?) -> ()) {
        store.retrive(completion: completion)
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map({ LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) })
    }
}

