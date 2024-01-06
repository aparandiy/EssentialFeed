//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 06.01.2024.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    func retrive(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }

}

class CodableFeedStoreTests: XCTestCase {
    
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
    
}
