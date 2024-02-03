//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 03.02.2024.
//

import UIKit

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedVC?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: FeedVC, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: FeedVM) {
        controller?.tableModel = viewModel.feed.map { model in
            
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)

            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init)

            return view
        }
    }
}
