//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 23.01.2024.
//

import Foundation
import EssentialFeed

public final class FeedUIComposer {
    
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedVC {
        let refreshController = FeedRefreshController(feedLoader: feedLoader)
        let feedVC = FeedVC(refreshController: refreshController)
        refreshController.onRefresh = { [weak feedVC] feed in
            guard let feedVC = feedVC else { return }
            feedVC.tableModel = feed.map { FeedImageCellController(model: $0, imageLoader: imageLoader) }
        }
        return feedVC
    }
}

