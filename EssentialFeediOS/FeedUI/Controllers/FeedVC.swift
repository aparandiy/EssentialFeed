//
//  FeedVC.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 19.01.2024.
//

import UIKit
import EssentialFeed

public final class FeedVC: UITableViewController, UITableViewDataSourcePrefetching {
    
    //MARK: - Properties
    public var feedRefreshControl: FeedRefreshController?
    private var imageLoader: FeedImageDataLoader?
    private var tableModel = [FeedImage]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var tasks = [IndexPath: FeedImageDataLoaderTask]()

    //MARK: - Init
    public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        self.feedRefreshControl = FeedRefreshController(feedLoader: feedLoader)
        self.imageLoader = imageLoader
    }
    
    //MARK: - Controller life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        feedRefreshControl?.onRefresh = { [weak self] feed in
            self?.tableModel = feed
        }
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
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (cellModel.location == nil)
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.feedImageContainer.startShimmering()
        cell.onRetry = loadImage(for: cell, at: indexPath, cellModel: cellModel)

        return cell
    }
    
    //MARK: - UITableViewDelegate
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FeedImageCell {
            let cellModel = tableModel[indexPath.row]
            loadImage(for: cell, at: indexPath, cellModel: cellModel)()
        }
    }

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelTask(forRowAt: indexPath)
    }
    
    //MARK: - UITableViewDataSourcePrefetching
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let cellModel = tableModel[indexPath.row]
            tasks[indexPath] = imageLoader?.loadImageData(from: cellModel.url) { _ in }
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelTask)
    }
    
    private func cancelTask(forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
    }
    
    //MARK: - API call
    @discardableResult
    func loadImage(for cell: FeedImageCell, at indexPath: IndexPath, cellModel: FeedImage) -> (()->(Void)) {
        let loadImage = { [weak self, weak cell] in
            guard let self = self else { return }

            self.tasks[indexPath] = self.imageLoader?.loadImageData(from: cellModel.url) { [weak cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell?.feedImageView.image = image
                cell?.feedImageRetryButton.isHidden = (image != nil)
                cell?.feedImageContainer.stopShimmering()
            }
        }
        return loadImage
    }
}
