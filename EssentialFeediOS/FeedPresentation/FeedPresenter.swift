//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 31.01.2024.
//

import Foundation
import EssentialFeed

struct FeedLoadingVM {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingVM)
}

struct FeedVM {
    let feed: [FeedImage]
}
protocol FeedView {
    func display(_ viewModel: FeedVM)
}

final class FeedPresenter {
    private var feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
            
    var feedView: FeedView?
    var feedLoadingView: FeedLoadingView?
    
    func loadFeed() {
        feedLoadingView?.display(FeedLoadingVM(isLoading: true))
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(FeedVM(feed: feed))
            }
            self?.feedLoadingView?.display(FeedLoadingVM(isLoading: false))
        }
    }
}
