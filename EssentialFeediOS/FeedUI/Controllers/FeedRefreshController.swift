//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 25.01.2024.
//

import UIKit
//protocol FeedLoadingView {
//    func display(isLoading: Bool)
//}
//
//protocol FeedView {
//    func display(feed: [FeedImage])
//}
public final class FeedRefreshController: NSObject, FeedLoadingView {
        
    private var feedPresenter: FeedPresenter

    init(feedPresenter: FeedPresenter) {
        self.feedPresenter = feedPresenter
    }
    
    public lazy var refreshIndicator = loadView()
        
    @objc func refresh() {
        feedPresenter.loadFeed()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
    //MARK: - FeedLoadingView
    func display(_ viewModel: FeedLoadingVM) {
        if viewModel.isLoading { refreshIndicator.beginRefreshing() }
        else {  refreshIndicator.endRefreshing() }
    }
}
