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
        let feedVM = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshController(viewModel: feedVM)
        let feedVC = FeedVC(refreshController: refreshController)
        feedVM.onFeedLoad = adaptFeedToCellController(forwardingTo: feedVC, loader: imageLoader)
        return feedVC
    }
    
    private static func adaptFeedToCellController(forwardingTo controller: FeedVC, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            guard let feedVC = controller else { return }
            feedVC.tableModel = feed.map { model in
                FeedImageCellController(viewModel: FeedImageVM(model: model, imageLoader: loader))
            }
        }
    }
}

