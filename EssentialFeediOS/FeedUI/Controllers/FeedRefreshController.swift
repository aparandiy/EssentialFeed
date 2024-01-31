//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 25.01.2024.
//

import UIKit

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedRefreshController: NSObject, FeedLoadingView {
        
    private let delegate: FeedRefreshViewControllerDelegate
    
    init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    public lazy var refreshIndicator = loadView()
        
    @objc func refresh() {
        delegate.didRequestFeedRefresh()
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
