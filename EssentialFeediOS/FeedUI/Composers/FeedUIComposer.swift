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
