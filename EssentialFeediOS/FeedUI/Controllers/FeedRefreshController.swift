//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 25.01.2024.
//

import UIKit
import EssentialFeed

public final class FeedRefreshController: NSObject {
    private var feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    public lazy var refreshIndicator: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    var onRefresh: (([FeedImage]) -> Void)?
    
    @objc func refresh() {
        refreshIndicator.beginRefreshing()
        feedLoader.load { [weak self] result in
            self?.refreshIndicator.endRefreshing()
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
        }
    }
}
