//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 14.12.2023.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}
protocol FeedLoader {
    func load(completion:@escaping (LoadFeedResult)->())
}
