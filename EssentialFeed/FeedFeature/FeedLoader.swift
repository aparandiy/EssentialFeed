//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 14.12.2023.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error>{
    case success([FeedItem])
    case failure(Error)
}

///this is an interface between UI module and concrete implementation of FeedLoader. It's like a guideline
protocol FeedLoader {
    associatedtype Error: Swift.Error
    func load(completion:@escaping (LoadFeedResult<Error>)->())
}
