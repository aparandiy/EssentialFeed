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
        feedRefreshControl.onRefresh = adaptFeedToCellController(forwardingTo: feedVC, loader: imageLoader)
        return feedVC
    }
    
    private static func adaptFeedToCellController(forwardingTo controller: FeedVC, loader: FeedImageDataLoader) -> ([FeedImage])->() {
        return { [weak controller] feed in
            guard let controller = controller else { return  }
            controller.tableModel = feed.map { FeedImageCellController(model: $0, imageLoader: loader) }
        }
    }
}
