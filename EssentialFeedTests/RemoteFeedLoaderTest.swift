//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 14.12.2023.
//

import XCTest
class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://url.com")
    }
}

class HTTPClient {
    static let shared = HTTPClient()
    ///this is a private init which prevents HTTPClient fo being created by someone more than once, so if someone needs a HTTPClient he can call anly a shared property and can't use let client = HTTPClient(). this is a real singletone "S"
    private init() {}
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient.shared
        let _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
