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
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader:
            MainQueueDispatchDecorator(decoratee: feedLoader))

        let feedVC = FeedVC.makeWith(delegate: presentationAdapter, title: "My Feed")
        presentationAdapter.presenter = FeedPresenter(feedView: 
                                                        FeedViewAdapter(
                                                            controller: feedVC,
                                                            imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
                                                      loadingView: WeakRefVirtualProxy(feedVC))

        return feedVC
    }
}

private extension FeedVC {
    static func makeWith(delegate: FeedVCDelegate, title: String) -> FeedVC {
        let bundle = Bundle(for: FeedVC.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedVC = storyboard.instantiateInitialViewController() as! FeedVC
        feedVC.title = FeedPresenter.title
        feedVC.delegate = delegate
        return feedVC
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
        controller?.tableModel = viewModel.feed.map { model in
            
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)

            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init)

            return view
        }
    }
}

private final class FeedLoaderPresentationAdapter: FeedVCDelegate {
    
    
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    //MARK: - FeedRefreshControllerDelegate
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
