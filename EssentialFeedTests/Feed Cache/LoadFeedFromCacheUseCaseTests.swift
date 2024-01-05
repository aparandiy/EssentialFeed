//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 03.01.2024.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval(){
        let (sut, store) = makeSUT()

        sut.load() { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError(){
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()

        expect(sut, completeWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_load_deliversNoImagesOnEmptyCache(){
        let (sut, store) = makeSUT()
        
        expect(sut, completeWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }
    }
    
    func test_load_deliversCachedImagesOnLessThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let lessThan7DaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        let (sut, store) = makeSUT(curentDate: { fixedCurrentDate })
        
        expect(sut, completeWith: .success(feed.models)) {
            store.completeRetrieval(with: feed.local, timestamp: lessThan7DaysOldTimestamp)
        }
    }
    
    func test_load_deliversNoImagesOnSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let sevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7)
        let (sut, store) = makeSUT(curentDate: { fixedCurrentDate })
        
        expect(sut, completeWith: .success([])) {
            store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimestamp)
        }
    }
    
    func test_load_deliversNoImagesOnMoreThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let moreThanSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: -1)
        let (sut, store) = makeSUT(curentDate: { fixedCurrentDate })
        
        expect(sut, completeWith: .success([])) {
            store.completeRetrieval(with: feed.local, timestamp: moreThanSevenDaysOldTimestamp)
        }
    }
    
    func test_load_deletesCacheOnRetrievalError(){
        let (sut, store) = makeSUT()
        
        sut.load { _ in}
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCashedFeed])
    }
    
    func test_load_doesNotDeletesCacheOnEmptyCache(){
        let (sut, store) = makeSUT()
        
        sut.load { _ in}
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    // MARK: - Helpers
    private func makeSUT(curentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, curentDate: curentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedLoader, completeWith expectedResult: LocalFeedLoader.LoadResult, when action: @escaping () -> (), file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImages), .success(expectedImages)):
                XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
                
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }

    private func uniqueImage() -> FeedImage {
        return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
    }
    
    private func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
        let models = [uniqueImage(), uniqueImage()]
        let local = models.map({ LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) })
        return (models, local)
    }

}


private extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
