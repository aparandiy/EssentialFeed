//
//  WeakRefVirtualProxy.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 03.02.2024.
//

import UIKit

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    
    func display(_ viewModel: FeedLoadingVM) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    func display(_ model: FeedImageVM<UIImage>) {
        object?.display(model)
    }
}
