//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 14.12.2023.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteFeedLoader {//final tag prevents of subclassing of this class, so nobody can be a subclass of the  RemoteFeedLoader
    let client: HTTPClient
    let url: URL
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load() {
        client.get(from: url)
    }
}
