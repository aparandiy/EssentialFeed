//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 14.12.2023.
//

import Foundation

public enum LoadFeedResult{
    case success([FeedItem])
    case failure(Error)
}

///this is an interface between UI module and concrete implementation of FeedLoader. It's like a guideline
public protocol FeedLoader {
    func load(completion:@escaping (LoadFeedResult)->())
}
