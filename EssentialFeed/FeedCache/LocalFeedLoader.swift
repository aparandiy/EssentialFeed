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
    
    public init(store: FeedStore, curentDate: @escaping () -> Date) {
        self.store = store
        self.curentDate = curentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [FeedItem], with completion: @escaping (Error?) -> ()) {
        store.insert(items, timestamp: curentDate(), completion: { [weak self] error in
            guard self != nil else { return }
            completion(error)
        })
    }
    
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}
