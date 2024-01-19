//
//  FeedVCTests.swift
//  EssentialFeediOSTests
//
//  Created by Andrij Parandij on 19.01.2024.
//

import XCTest

final class FeedVC {
    init(loader: FeedVCTests.LoaderSpy) {

    }
}

final class FeedVCTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedVC(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helpers
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
