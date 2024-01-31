//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 25.01.2024.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedVC {
        
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)
        let feedRefreshControl = FeedRefreshController(delegate: presentationAdapter)
        let feedVC = FeedVC(feedRefreshControl: feedRefreshControl)
        presentationAdapter.presenter = FeedPresenter(feedView: FeedViewAdapter(controller: feedVC, imageLoader: imageLoader),
                                      feedLoadingView: WeakRefVirtualProxy(feedRefreshControl))
        return feedVC
    }
    
    private static func adaptFeedToCellController(forwardingTo controller: FeedVC, loader: FeedImageDataLoader) -> ([FeedImage])->() {
        return { [weak controller] feed in
            guard let controller = controller else { return  }
            controller.tableModel = feed.map { FeedImageCellController(viewModel: FeedImageCellVM(model: $0, imageLoader: loader, imageTransformer: UIImage.init)) }
        }
    }
}

private final class FeedViewAdapter: FeedView {
    private weak var controller: FeedVC?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: FeedVC, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedVM) {
        controller?.tableModel = viewModel.feed.map { FeedImageCellController(viewModel: FeedImageCellVM(model: $0, imageLoader: imageLoader, imageTransformer: UIImage.init)) }
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingVM) {
        object?.display(viewModel)
    }
}

private final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {
        
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    //MARK: - FeedRefreshViewControllerDelegate
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()

        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)

            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }

}
