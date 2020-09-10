//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeed
import XCTest

class ImageCommentPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didFinishLoadingImageComment_displaysImageOnSuccessfulTransformation() {
        let comment = uniqueComment
        let formatter = DateFormatter()
        let (sut, view) = makeSUT(dateFormatter: { formatter.string(from: $0) })

        sut.didFinishLoadingImageComment(for: comment)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.username, comment.username)
        XCTAssertEqual(message?.message, comment.message)
        XCTAssertEqual(message?.createdAt, formatter.string(from: comment.createdAt))
    }

    // MARK: - Helpers

    private func makeSUT(
        dateFormatter: @escaping (Date) -> String = { _ in "" },
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: ImageCommentPresenter<ViewSpy>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = ImageCommentPresenter(view: view, dateFormatter: dateFormatter)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private class ViewSpy: ImageCommentView {
        private(set) var messages = [ImageCommentViewModel]()

        func display(_ model: ImageCommentViewModel) {
            messages.append(model)
        }
    }

}
