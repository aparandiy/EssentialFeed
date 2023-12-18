//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 14.12.2023.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {//final tag prevents of subclassing of this class, so nobody can be a subclass of the  RemoteFeedLoader
    let client: HTTPClient
    let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult<Error>
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    //MARK: - FeedLoader
    public func load(completion: @escaping (Result) ->()) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

