//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 01.01.2024.
//

import XCTest
class LocalFeedLoader {
    
    init(store: FeedStore) {
        
    }
}
class FeedStore {
    var deleteCachedFeedCallCount = 0
}
class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() {
         let store = FeedStore()
         _ = LocalFeedLoader(store: store)

         XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
     }
}
