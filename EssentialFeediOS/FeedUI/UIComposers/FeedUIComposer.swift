//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 25.01.2024.
//

import EssentialFeed

public final class FeedUIComposer {
    
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedVC {
        let feedRefreshControl = FeedRefreshController(feedLoader: feedLoader)
        let feedVC = FeedVC(feedRefreshControl: feedRefreshControl)
        feedRefreshControl.onRefresh = { [weak feedVC] feed in
            guard let feedVC = feedVC else { return  }
            feedVC.tableModel = feed.map({ FeedImageCellController(model: $0, imageLoader: imageLoader) })
        }
        return feedVC
    }
}
