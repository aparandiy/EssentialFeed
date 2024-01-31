//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 31.01.2024.
//

import Foundation
import EssentialFeed

protocol FeedLoadingView {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    private var feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
            
    var feedView: FeedView?
    var feedLoadingView: FeedLoadingView?
    
    func loadFeed() {
        feedLoadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.feedLoadingView?.display(isLoading: false)
        }
    }
}
