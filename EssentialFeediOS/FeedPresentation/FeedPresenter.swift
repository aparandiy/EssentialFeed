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
            
    private let feedView: FeedView
    private let feedLoadingView: FeedLoadingView
    
    init(feedView: FeedView, feedLoadingView: FeedLoadingView) {
        self.feedView = feedView
        self.feedLoadingView = feedLoadingView
    }
    
    func didStartLoadingFeed() {
        feedLoadingView.display(FeedLoadingVM(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedVM(feed: feed))
        feedLoadingView.display(FeedLoadingVM(isLoading: false))
    }

    func didFinishLoadingFeed(with error: Error) {
        feedLoadingView.display(FeedLoadingVM(isLoading: false))
    }
}
