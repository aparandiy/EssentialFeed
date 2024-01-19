//
//  FeedVCTests.swift
//  EssentialFeediOSTests
//
//  Created by Andrij Parandij on 19.01.2024.
//

import XCTest
import EssentialFeed

final class FeedVC: UIViewController {
    private var loader: FeedLoader?

    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loader?.load { _ in}
    }
}

final class FeedVCTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedVC(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helpers
    class LoaderSpy: FeedLoader {
        private(set) var loadCallCount: Int = 0
        
        func load(completion: @escaping (FeedLoader.Result) -> ()) {
            loadCallCount += 1
        }
    }
}
