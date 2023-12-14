//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 14.12.2023.
//

import XCTest
class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "test2")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "test")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {// this is a class just for test, we are not using it somewhere else, so we moved it to the test scope and made it private
        //MARK: - Properties
        var requestedURL: URL?

        //MARK: HTTPClient
        func get(from url: URL) {
            requestedURL = url
        }
    }

}
