//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 29.01.2024.
//

import EssentialFeed

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingVM)
}

protocol FeedView {
    func display(_ viewModel: FeedVM)
}

final class FeedPresenter {

    static var title: String {
        let bundle = Bundle(for: FeedPresenter.self)
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: bundle, comment: "Title for the Feed view")
    }
    
    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    
    init(feedView: FeedView, loadingView: FeedLoadingView) {
        self.feedView = feedView
        self.loadingView = loadingView
    }
    
    func didStartLoadingFeed() {
        loadingView.display(FeedLoadingVM(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedVM(feed: feed))
        loadingView.display(FeedLoadingVM(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingVM(isLoading: false))
    }
}
