//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 06.01.2024.
//

import XCTest
import EssentialFeed

class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {//called before the invocation of each test method in the class
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {//called after the class has finished running all tests
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    
    func test_retrieve_deliversEmptyOnEmptyCache(){
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache(){
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .empty)
    }
        
    func test_retrieve_deliversFoundValuesOnNonEmptyCache(){

        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrieve_hasNonSideEffectsOnNonEmptyCache(){

        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrieve_deliversErrorOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "InavalidData".write(to: testSpecificStoreURL(), atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func test_retrieve_hasNoSideEffectsOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "InavalidData".write(to: testSpecificStoreURL(), atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func test_insert_ovveridesPreviouslyInsertedValues() {
        let sut = makeSUT()
        
        let firstInsertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache succesfully")

        let latestFeed = uniqueImageFeed().local
        let latestTimestamp = Date()
        let latestInsertionError = insert((latestFeed, latestTimestamp), to: sut)
        
        XCTAssertNil(latestInsertionError, "Expected to insert cache succesfully")
        expect(sut, toRetrieveTwice: .found(feed: latestFeed, timestamp: latestTimestamp))
    }
    
    func test_insert_deliversErrorOnInsertionError() {
         let invalidStoreURL = URL(string: "invalid://store-url")!
         let sut = makeSUT(storeURL: invalidStoreURL)
         let feed = uniqueImageFeed().local
         let timestamp = Date()

         let insertionError = insert((feed, timestamp), to: sut)

         XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
         expect(sut, toRetrieve: .empty)
     }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
         let sut = makeSUT()
         let deletionError = deleteCache(from: sut)

         XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")

         expect(sut, toRetrieve: .empty)
     }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
         let sut = makeSUT()
         insert((uniqueImageFeed().local, Date()), to: sut)

         let deletionError = deleteCache(from: sut)

         XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")

         expect(sut, toRetrieve: .empty)
     }
    
    func test_delete_deliversErrorOnDeletionError() {
        let sut = makeSUT(storeURL: noDeletePermissionURL())

        let deletionError = deleteCache(from: sut)

        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
        expect(sut, toRetrieve: .empty)
    }
    
    func test_storeSideEffects_runSerially() {
         let sut = makeSUT()
         var completedOperationsInOrder = [XCTestExpectation]()

         let op1 = expectation(description: "Operation 1")
         sut.insert(uniqueImageFeed().local, timestamp: Date()) { _ in
             completedOperationsInOrder.append(op1)
             op1.fulfill()
         }

         let op2 = expectation(description: "Operation 2")
         sut.deleteCachedFeed { _ in
             completedOperationsInOrder.append(op2)
             op2.fulfill()
         }

         let op3 = expectation(description: "Operation 3")
         sut.insert(uniqueImageFeed().local, timestamp: Date()) { _ in
             completedOperationsInOrder.append(op3)
             op3.fulfill()
         }

         waitForExpectations(timeout: 5.0)

         XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
     }

    
    //MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> FeedStore {

        let sut = CodableFeedStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        
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
    private func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    private func deleteCache(from sut: FeedStore) -> Error? {
         let exp = expectation(description: "Wait for cache deletion")
         var deletionError: Error?
         sut.deleteCachedFeed { receivedDeletionError in
             deletionError = receivedDeletionError
             exp.fulfill()
         }
         wait(for: [exp], timeout: 1.0)
         return deletionError
     }
    
    private func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func noDeletePermissionURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .systemDomainMask).first!
    }


}
