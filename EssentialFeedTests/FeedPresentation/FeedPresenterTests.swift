//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 12.02.2024.
//

import XCTest

struct FeedErrorVM {
    let message: String?
    
    static var noError: FeedErrorVM {
        return FeedErrorVM(message: nil)
    }
}

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorVM)
}

final class FeedPresenter {
    private let errorView: FeedErrorView

    init(errorView: FeedErrorView) {
        self.errorView = errorView
    }
    
    func didStartLoadingFeed() {
        errorView.display(.noError)
    }
}

final class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingFeed_displaysNoErrorMessage() {
        let (sut, view) = makeSUT()

        sut.didStartLoadingFeed()

        XCTAssertEqual(view.messages, [.display(errorMessage: .none)])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    
    private class ViewSpy: FeedErrorView {
        func display(_ viewModel: FeedErrorVM) {
            messages.append(.display(errorMessage: viewModel.message))
        }
        
        enum Message: Equatable {
            case display(errorMessage: String?)
        }
        
        private(set) var messages = [Message]()
    }


}
