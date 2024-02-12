//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 12.02.2024.
//

import XCTest

struct FeedLoadingVM {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingVM)
}

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
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView

    init(loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.loadingView = loadingView
        self.errorView = errorView
    }

    func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingVM(isLoading: true))
    }
}

final class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingFeed_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()

        sut.didStartLoadingFeed()

        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(loadingView: view, errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    
    private class ViewSpy: FeedLoadingView, FeedErrorView {
        func display(_ viewModel: FeedErrorVM) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: FeedLoadingVM) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
        }
        
        private(set) var messages = Set<Message>()
    }


}
