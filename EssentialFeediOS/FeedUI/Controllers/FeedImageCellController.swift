//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 23.01.2024.
//

import UIKit

protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class FeedImageCellController: FeedImageView {

    private let delegate: FeedImageCellControllerDelegate
    private lazy var cell = FeedImageCell()
    
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view() -> FeedImageCell {
        delegate.didRequestImage()
        return cell
    }
            
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        delegate.didCancelImageRequest()
    }
    
    //MARK: - FeedImageView
    func display(_ viewModel: FeedImageVM<UIImage>) {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.feedImageView.image = viewModel.image
        cell.feedImageContainer.isShimmering = viewModel.isLoading
        cell.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        cell.onRetry = delegate.didRequestImage
    }
}
