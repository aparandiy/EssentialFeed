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

//class HTTPClient {
//    ///this is a private init which prevents HTTPClient fo being created by someone more than once, so if someone needs a HTTPClient he can call anly a shared property and can't use let client = HTTPClient(). this is a real singletone "S"
////    static let shared = HTTPClient()
////    private init() {}
//
//
//    ///this is not a singlton, because static var an opportunity to create a new instance with HTTPClient() and override the current static shared instance like
//    ///let newClient = HTTPClient()
//    ///HTTPClient.shared = newClient
////    static var shared = HTTPClient()
//
//    func get(from url: URL) { }
//}
//
//class HTTPClientSpy: HTTPClient {
//    override func get(from url: URL) {
//        requestedURL = url
//    }
//
//    var requestedURL: URL?
//}


//Instead of using the class HTTPClient we can use a protocol HTTPClient, because it's just an abstaction, so who ever want the use HTTPSClien - he is responsable for implemetion of this protocol, this is a dependecy inversion
protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    //MARK: - Properties
    var requestedURL: URL?

    //MARK: HTTPClient
    func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        ///static var instance of shared HTTPClient object gives us an opportunity to rewrite it with a subclass wich is our HTTPSClientSpy
//        HTTPClient.shared = client
//        let _ = RemoteFeedLoader()
        
        ///Instead fo using a shared instance(singletone) we decided to make a constrcutor injection, so now RemoteFeedLoader can beconly initialized with the client, so who ever creates the RemoteFeedLoader needs to pass a client to it let _ = RemoteFeedLoader(client: client)
        let _ = RemoteFeedLoader(client: client, url: URL(string: "https://url.com")!)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "test")!
        let client = HTTPClientSpy()
        ///static var instance of shared HTTPClient object gives us an opportunity to rewrite it with a subclass wich is our HTTPSClientSpy
//        HTTPClient.shared = client
//        let sut = RemoteFeedLoader()
        
        ///Instead fo using a shared instance(singletone) we decided to make a constrcutor injection, so now RemoteFeedLoader can beconly initialized with the client, so who ever creates the RemoteFeedLoader needs to pass a client to it let _ = RemoteFeedLoader(client: client)
        let sut = RemoteFeedLoader(client: client, url: url)
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
}
