//
//  FeedVC.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 19.01.2024.
//

import UIKit

public final class FeedVC: UITableViewController, UITableViewDataSourcePrefetching {
    
    //MARK: - Properties
    public var feedRefreshControl: FeedRefreshController?
    var tableModel = [FeedImageCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Init
    convenience init(feedRefreshControl: FeedRefreshController) {
        self.init()
        self.feedRefreshControl = feedRefreshControl
    }
    
    //MARK: - Controller life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = feedRefreshControl?.refreshIndicator
        
        tableView.prefetchDataSource = self
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        feedRefreshControl?.refresh()
    }
        
    //MARK: - UITableViewDatasource
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableModel[indexPath.row].cell()
    }
    
    //MARK: - UITableViewDelegate
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(at: indexPath)
    }
    
    //MARK: - UITableViewDataSourcePrefetching
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            tableModel[indexPath.row].preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    //MARK: - Helpers
    private func cancelCellControllerLoad(at indexPath: IndexPath) {
        tableModel[indexPath.row].cancelLoad()
    }
}
