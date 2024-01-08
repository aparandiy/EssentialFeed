//
//  XCTestCase+FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 08.01.2024.
//

import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for cache retrieval completion")
            
        sut.retrive { retrieveResult in
            switch (expectedResult, retrieveResult) {
            case (.empty, .empty), (.failure, .failure):
                break
                
            case let (.found(feed: expectedFeed, timestamp: expectedTimestamp), .found(feed: retrievedFeed, timestamp: retrievedTimestamp)):
                XCTAssertEqual(expectedFeed, retrievedFeed)
                XCTAssertEqual(expectedTimestamp, retrievedTimestamp)

            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrieveResult) instead, file: \(file), line: \(line)")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func deleteCache(from sut: FeedStore) -> Error? {
         let exp = expectation(description: "Wait for cache deletion")
         var deletionError: Error?
         sut.deleteCachedFeed { receivedDeletionError in
             deletionError = receivedDeletionError
             exp.fulfill()
         }
         wait(for: [exp], timeout: 1.0)
         return deletionError
     }
    
    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

}
