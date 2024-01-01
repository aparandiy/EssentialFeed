//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 01.01.2024.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
    private let store: FeedStore
    private let curentDate: () -> Date
    
    init(store: FeedStore, curentDate: @escaping () -> Date) {
        self.store = store
        self.curentDate = curentDate
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed { [unowned self] error in
            if error == nil {
                self.store.insert(items, timestamp: self.curentDate())
            }
        }
    }
    
}
class FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    
    enum ReceivedMessage: Equatable {
        case deleteCashedFeed
        case insert([FeedItem], Date)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private var deletionCompletions = [DeletionCompletion]()
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCashedFeed)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ items: [FeedItem], timestamp: Date) {
        receivedMessages.append(.insert(items, timestamp))
    }
}
class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
         let items = [uniqueItem(), uniqueItem()]
         let (sut, store) = makeSUT()

         sut.save(items)

        XCTAssertEqual(store.receivedMessages, [.deleteCashedFeed])
     }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()

        sut.save(items)
        store.completeDeletion(with: deletionError)

        XCTAssertEqual(store.receivedMessages, [.deleteCashedFeed])
    }
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
         let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT(curentDate: { timestamp })

         sut.save(items)
         store.completeDeletionSuccessfully()

        XCTAssertEqual(store.receivedMessages, [.deleteCashedFeed, .insert(items, timestamp)])
     }
    
    // MARK: - Helpers
    private func makeSUT(curentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store, curentDate: curentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
     }
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

}
