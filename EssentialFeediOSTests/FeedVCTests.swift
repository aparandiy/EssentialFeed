//
//  FeedVCTests.swift
//  EssentialFeediOSTests
//
//  Created by Andrij Parandij on 19.01.2024.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

final class FeedVCTests: XCTestCase {

    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")

        sut.beginAppearanceTransition(true, animated: false)//calls view will Appear
        sut.endAppearanceTransition()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_viewDidLoad_doesNotshowsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()

        sut.beginAppearanceTransition(true, animated: false)//calls view will Appear
        sut.endAppearanceTransition()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        loader.completeFeedLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedVC, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedVC(loader: loader)
        sut.replaceRefreshControlWithFake()
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void]()

        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> ()) {
            completions.append(completion)
        }
        
        func completeFeedLoading(at index: Int) {
            completions[index](.success([]))
        }
    }
}

private extension UITableViewController {
    func replaceRefreshControlWithFake() {
        let fake = FakeRefreshControl()
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                fake.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }
        
        self.refreshControl = fake
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

private class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool {
        return _isRefreshing
    }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}

private extension FeedVC {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
}
