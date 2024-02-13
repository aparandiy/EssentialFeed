//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 13.02.2024.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
