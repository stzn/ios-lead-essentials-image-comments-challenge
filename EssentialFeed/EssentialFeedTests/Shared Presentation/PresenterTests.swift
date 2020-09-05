//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class PresenterTests: XCTestCase {
    func test_title_set() {
        let title = "any title"
        let (sut, _) = makeSUT(title: title)
        XCTAssertEqual(sut.title, title)
    }

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didStartLoadingFeed_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()

        sut.didStartLoading()

        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }

    func test_didFinishLoadingFeed_displaysFeedAndStopsLoading() {
        let (sut, view) = makeSUT()
        let content = "content"

        sut.didFinishLoading(with: content)

        XCTAssertEqual(view.messages, [
            .display(view: content),
            .display(isLoading: false)
        ])
    }

    func test_didFinishLoadingFeedWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()

        sut.didFinishLoading(with: anyNSError())

        XCTAssertEqual(view.messages, [
            .display(errorMessage: localized("VIEW_CONNECTION_ERROR")),
            .display(isLoading: false)
        ])
    }

    // MARK: - Helpers

    private func makeSUT(title: String = "any",
                         file: StaticString = #file, line: UInt = #line) -> (sut: Presenter<ViewSpy>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = Presenter<ViewSpy>(title: title, view: view, loadingView: view, errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Presenter"
        let bundle = Bundle(for: Presenter<ViewSpy>.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }

    private class ViewSpy: View, LoadingView, ErrorView {
        typealias ViewModel = String

        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(view: String)
        }

        private(set) var messages = Set<Message>()

        func display(_ viewModel: ErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }

        func display(_ viewModel: LoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }

        func display(_ viewModel: ViewModel) {
            messages.insert(.display(view: viewModel))
        }
    }

}
