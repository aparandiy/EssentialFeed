//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 14.12.2023.
//

import Foundation

///this is an interface between UI module and concrete implementation of FeedLoader. It's like a guideline
public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>

    func load(completion:@escaping (Result)->())
}
