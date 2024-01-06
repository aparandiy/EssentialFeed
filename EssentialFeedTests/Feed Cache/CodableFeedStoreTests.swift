//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 06.01.2024.
//

import XCTest
import EssentialFeed



class CodableFeedStore {
    
    private struct Cache: Codable {
        let feed: [LocalFeedImage]
        let timestamp: Date
    }
    
    private let storeURL = FileManager.default.urls(for: .userDirectory, in: .userDomainMask).first!.appending(component: "image-feed.store")
    
    func retrive(completion: @escaping FeedStore.RetrievalCompletion) {
        
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.feed, timestamp: cache.timestamp))
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let encodedData = try! encoder.encode(Cache(feed: feed, timestamp: timestamp))
        try! encodedData.write(to: storeURL)
    }
}

class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {//called before the invocation of each test method in the class
        super.setUp()

        let storeURL = FileManager.default.urls(for: .userDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")//(component: "image-feed.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    override class func tearDown() {//called after the class has finished running all tests
        super.tearDown()
        
        let storeURL = FileManager.default.urls(for: .userDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")//(component: "image-feed.store")
        try? FileManager.default.removeItem(at: storeURL)

    }
    
    func test_retrieve_deliversEmptyOnEmptyCache(){
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval completion")
        
        sut.retrive { result in
            switch result {
            case .empty: break
            default:
                XCTFail("Expected empty result got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache(){
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval completion")
        
        sut.retrive { firstResult in
            sut.retrive { secondResult in
                
                switch (firstResult, secondResult) {
                case (.empty, .empty): break
                default:
                    XCTFail("Expected empty result got \(firstResult) and \(secondResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsrtedValues(){

        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval completion")
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            
            sut.retrive { retrieveResult in
                switch retrieveResult {
                case let .found(retrievedFeed, retrievedTimestamp):
                    XCTAssertEqual(feed, retrievedFeed)
                    XCTAssertEqual(timestamp, retrievedTimestamp)

                default:
                    XCTFail("Expected found result with feed \(feed) and timestamp \(timestamp), got \(retrieveResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1)
    }
    


    
}
