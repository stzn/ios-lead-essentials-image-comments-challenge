////	
//// Copyright © 2020 Essential Developer. All rights reserved.
////
//
//import XCTest
//import EssentialFeed
//
//class ImageCommentsPresenterTests: XCTestCase {
//
//    func test_title_isLocalized() {
//        XCTAssertEqual(ImageCommentsLocalizedString.title, localized("VIEW_TITLE"))
//    }
//
//    func test_init_doesNotSendMessagesToView() {
//        let (_, view) = makeSUT()
//
//        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
//    }
//
//    func test_didFinishLoadingImageComments_displaysFeedAndStopsLoading() {
//        let (sut, view) = makeSUT()
//        let comments = [uniqueComment]
//
//        sut.didFinishLoadingImageComments(with: comments)
//
//        XCTAssertEqual(view.messages, [
//            .display(comments: comments),
//            .display(isLoading: false)
//        ])
//    }
//
//    // MARK: - Helpers
//
//    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: Presenter<ViewSpy, [String]>, view: ViewSpy) {
//        let view = ViewSpy()
//        let sut = Presenter<ViewSpy, String>(commentView: view, loadingView: view, errorView: view)
//        trackForMemoryLeaks(view, file: file, line: line)
//        trackForMemoryLeaks(sut, file: file, line: line)
//        return (sut, view)
//    }
//
//    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
//        let table = "ImageComments"
//        let bundle = Bundle(for: ImageCommentsPresenter.self)
//        let value = bundle.localizedString(forKey: key, value: nil, table: table)
//        if value == key {
//            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
//        }
//        return value
//    }
//
//    private class ViewSpy: View, LoadingView, ErrorView {
//        typealias Content = [String]
//
//        enum Message: Hashable {
//            case display(errorMessage: String?)
//            case display(isLoading: Bool)
//            case display(comments: [ImageComment])
//        }
//
//        private(set) var messages = Set<Message>()
//
//        func display(_ viewModel: ErrorViewModel) {
//            messages.insert(.display(errorMessage: viewModel.message))
//        }
//
//        func display(_ viewModel: LoadingViewModel) {
//            messages.insert(.display(isLoading: viewModel.isLoading))
//        }
//
//        func display(_ viewModel: ImageCommentsViewModel) {
//            messages.insert(.display(comments: viewModel.comments))
//        }
//    }
//
//    private var uniqueComment: ImageComment {
//        return ImageComment(id: UUID(), message: "any message", createdAt: Date(), username: "any username")
//    }
//}
