//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 14.12.2023.
//

import XCTest
//@testable import EssentialFeed @testable tag gives access to all the internal classes of the module, since EssentialFeed is a sepatare EssentialFeed - RemoteFeedLoaderTests can't reach his not public classes
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURLTwice(){
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load { _ in }
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse(){
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                let json = makeItemsJson([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJson(){
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJson = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJson)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJsonList(){
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyJson = makeItemsJson([])
            client.complete(withStatusCode: 200, data: emptyJson)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJsonItems(){
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: UUID(),
                             imageURL: URL(string: "http://a-url.com")!)
        
        let item2 = makeItem(id: UUID(),
                             description: "a description",
                             location: "a location",
                             imageURL: URL(string: "http://another-url.com")!)
        
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items)) {
            let json = makeItemsJson([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line ) -> (RemoteFeedLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        trackForMemoryLeak(sut)
        trackForMemoryLeak(client)
        return (sut, client)
    }
    
    private func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in//a block which runs after each test completion
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedItem, json: [String : Any]) {
        let item = FeedItem(id: id, description: description, location: location, imageURL: imageURL)
        
//        var itemJson = [
//            "id" : item.id.uuidString,
//            "image" : item.imageURL.absoluteString
//        ]
//
//        if let description = description {
//            itemJson["description"] = description
//        }
//
//        if let location = location {
//            itemJson["location"] = location
//        }
        //same as ->
        let itemJson = [
            "id" : item.id.uuidString,
            "description" : item.description,
            "location" : item.location,
            "image" : item.imageURL.absoluteString
        ].reduce(into: [String : Any]()) { (newDict, oldDict) in
            if let value = oldDict.value { newDict[oldDict.key] = value }
        }
    
        return (model: item, json: itemJson)
    }
    
    private func makeItemsJson(_ items: [[String : Any]]) -> Data {
        let itemsJSON = ["items" : items]
        return try! JSONSerialization.data(withJSONObject: itemsJSON)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt =  #line) {
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line )
    }
        
    private class HTTPClientSpy: HTTPClient {// this is a class just for test, we are not using it somewhere else, so we moved it to the test scope and made it private
        //MARK: - Properties
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

        var requestedURLs: [URL] {
            return messages.map{$0.url}
        }
        
        //MARK: HTTPClient
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error:Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success(data, response))
        }
    }
}
