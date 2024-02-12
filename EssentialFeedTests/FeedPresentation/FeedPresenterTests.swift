//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 12.02.2024.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {

    }
}

final class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()

        _ = FeedPresenter(view: view)

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    private class ViewSpy {
        let messages = [Any]()
    }


}
