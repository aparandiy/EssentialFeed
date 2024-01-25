//
//  FeedVM.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 25.01.2024.
//

import Foundation
import EssentialFeed

final class FeedVM {
    private var feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
            
    var onChange: ((FeedVM) -> ())?
    var onFeedLoad: (([FeedImage]) -> Void)?

    private(set) var isLoading: Bool = false {
        didSet{
            onChange?(self)
        }
    }
    
    func loadFeed() {
        isLoading = true
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.isLoading = false
        }
    }
}
