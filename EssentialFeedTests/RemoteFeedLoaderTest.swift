//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 14.12.2023.
//

import XCTest
class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://url.com")!)
    }
}

class HTTPClient {
    ///this is a private init which prevents HTTPClient fo being created by someone more than once, so if someone needs a HTTPClient he can call anly a shared property and can't use let client = HTTPClient(). this is a real singletone "S"
//    static let shared = HTTPClient()
//    private init() {}
    
    
    ///this is not a singlton, because static var an opportunity to create a new instance with HTTPClient() and override the current static shared instance like
    ///let newClient = HTTPClient()
    ///HTTPClient.shared = newClient
    static var shared = HTTPClient()
    
    func get(from url: URL) { }
}

class HTTPClientSpy: HTTPClient {
    override func get(from url: URL) {
        requestedURL = url
    }
    
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        ///static var instance of shared HTTPClient object gives us an opportunity to rewrite it with a subclass wich is our HTTPSClientSpy
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
