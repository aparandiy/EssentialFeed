//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 03.02.2024.
//

import EssentialFeed

final class FeedLoaderPresentationAdapter: FeedVCDelegate {
    
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
