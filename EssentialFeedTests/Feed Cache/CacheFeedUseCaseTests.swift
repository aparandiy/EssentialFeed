//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 01.01.2024.
//

import XCTest
import EssentialFeed

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
         let (sut, store) = makeSUT()

        sut.save(uniqueImageFeed().models) { _ in}

        XCTAssertEqual(store.receivedMessages, [.deleteCashedFeed])
     }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()

        sut.save(uniqueImageFeed().models) { _ in}
        store.completeDeletion(with: deletionError)

        XCTAssertEqual(store.receivedMessages, [.deleteCashedFeed])
    }
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let feed = uniqueImageFeed()
        let (sut, store) = makeSUT(curentDate: { timestamp })

        sut.save(feed.models) { _ in}
        store.completeDeletionSuccessfully()

        XCTAssertEqual(store.receivedMessages, [.deleteCashedFeed, .insert(feed.local, timestamp)])
     }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()

        expect(sut: sut, toCompleteWithError: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()

        expect(sut: sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }

    func test_save_succeedsOnSuccessfullCacheInsertion() {
        let (sut, store) = makeSUT()

        expect(sut: sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, curentDate: Date.init)
        
        var receivedResults = [LocalFeedLoader.SaveResult]()
        sut?.save(uniqueImageFeed().models, completion: { error in
            receivedResults.append(error)
        })
        
        sut = nil
        store.completeDeletion(with: NSError(domain: "any error", code: 0))
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, curentDate: Date.init)
        
        var receivedResults = [LocalFeedLoader.SaveResult]()
        sut?.save(uniqueImageFeed().models, completion: { error in
            receivedResults.append(error)
        })
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: NSError(domain: "any error", code: 0))
        
        XCTAssertTrue(receivedResults.isEmpty)
    }

    
    // MARK: - Helpers
    private func makeSUT(curentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, curentDate: curentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    func expect(sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: @escaping () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for save completion")
        var receivedError: Error?
        sut.save(uniqueImageFeed().models) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)

    }
}
