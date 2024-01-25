//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 25.01.2024.
//

import UIKit

public final class FeedRefreshController: NSObject {
    private var feedVM: FeedVM

    init(viewModel: FeedVM) {
        self.feedVM = viewModel
    }
    
    public lazy var refreshIndicator = binded(UIRefreshControl())
        
    @objc func refresh() {
        feedVM.loadFeed()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        feedVM.onChange = { [weak self] newFeedVM in
            if newFeedVM.isLoading { self?.refreshIndicator.beginRefreshing() }
            else {  self?.refreshIndicator.endRefreshing() }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
