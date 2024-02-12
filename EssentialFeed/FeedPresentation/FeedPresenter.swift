//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 12.02.2024.
//


public protocol FeedView {
    func display(_ viewModel: FeedVM)
}

public struct FeedLoadingVM {
    public let isLoading: Bool
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingVM)
}

public struct FeedErrorVM {
    public let message: String?
    
    static var noError: FeedErrorVM {
        return FeedErrorVM(message: nil)
    }
    
    static func error(message: String) -> FeedErrorVM {
        return FeedErrorVM(message: message)
    }
}

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorVM)
}

public final class FeedPresenter {
    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the feed view")
    }


    public init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }

    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingVM(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedVM(feed: feed))
        loadingView.display(FeedLoadingVM(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(FeedLoadingVM(isLoading: false))
    }
}
