//
//  FeedRefreshVC.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 23.01.2024.
//

import UIKit
import EssentialFeed

public class FeedRefreshController: NSObject {
    public lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onRefresh: (([FeedImage]) -> Void)?
    
    @objc func refresh() {
        refreshControl.beginRefreshing()
        feedLoader.load { [weak self] result in
            self?.refreshControl.endRefreshing()
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
        }
    }
}
