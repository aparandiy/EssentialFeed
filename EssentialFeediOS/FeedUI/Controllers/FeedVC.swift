//
//  FeedVC.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 19.01.2024.
//

import UIKit
import EssentialFeed

protocol FeedVCDelegate {
    func didRequestFeedRefresh()
}

public final class FeedVC: UITableViewController, UITableViewDataSourcePrefetching, FeedLoadingView, FeedErrorView {
    
    //MARK: - Properties
    var delegate: FeedVCDelegate?
    @IBOutlet private(set) public var errorView: ErrorView?

    var tableModel = [FeedImageCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Controller life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        refresh()
    }
    
    //MARK: - RefreshControl action
    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh()
    }
        
    //MARK: - UITableViewDatasource
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    //MARK: - UITableViewDelegate
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    //MARK: - UITableViewDataSourcePrefetching
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    //MARK: - Helpers
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        tableModel[indexPath.row].cancelLoad()
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
    }
    
    //MARK: - FeedLoadingView
    public func display(_ viewModel: FeedLoadingVM) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
    
    //MARK: - FeedErrorView
    public func display(_ viewModel: FeedErrorVM) {
        errorView?.message = viewModel.message
    }

}
