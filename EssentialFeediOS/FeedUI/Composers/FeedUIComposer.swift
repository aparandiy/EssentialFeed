//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 23.01.2024.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedVC {
        let presenter = FeedPresenter(feedLoader: feedLoader)
        let refreshController = FeedRefreshController(presenter: presenter)
        let feedVC = FeedVC(refreshController: refreshController)
        presenter.loadingView = WeakRefVirtualProxy(refreshController)
        presenter.feedView = FeedViewAdapter(controller: feedVC, imageLoader: imageLoader)
        return feedVC
    }
    
    private static func adaptFeedToCellController(forwardingTo controller: FeedVC, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            guard let feedVC = controller else { return }
            feedVC.tableModel = feed.map { model in
                FeedImageCellController(viewModel: FeedImageVM(model: model, imageLoader: loader, imageTransformer: UIImage.init))
            }
        }
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}

private final class FeedViewAdapter: FeedView {
    private weak var controller: FeedVC?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: FeedVC, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(feed: [FeedImage]) {
        controller?.tableModel = feed.map { model in
            FeedImageCellController(viewModel:
                FeedImageVM(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
        }
    }
}


