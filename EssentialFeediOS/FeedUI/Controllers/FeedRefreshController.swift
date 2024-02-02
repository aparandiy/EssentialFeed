//
//  FeedRefreshVC.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 23.01.2024.
//

import UIKit
protocol FeedRefreshControllerDelegate {
    func didRequestFeedRefresh()
}

public class FeedRefreshController: NSObject, FeedLoadingView {
        
//    public lazy var refreshControl = loadView()
    @IBOutlet public var refreshControl: UIRefreshControl!
    
    var delegate: FeedRefreshControllerDelegate?

    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
//    private func loadView() -> UIRefreshControl {
//        let view = UIRefreshControl()
//        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
//        return view
//    }
    
    //MARK: - FeedLoadingView
    func display(_ viewModel: FeedLoadingVM) {
        if viewModel.isLoading {
            refreshControl.beginRefreshing()
        } else {
            refreshControl.endRefreshing()
        }
    }

}
