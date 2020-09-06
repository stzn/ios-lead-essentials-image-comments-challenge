//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didFinishLoadingComment_displaysLoadingComment() {
        let dateFormatter = { date in
            return DateFormatter().string(from: date)
        }
        let (sut, view) = makeSUT(dateFormatter: dateFormatter)
        let comment = uniqueImageComment()
        
        sut.didFinishLoadingComment(with: comment)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.username, comment.username)
        XCTAssertEqual(message?.message, comment.message)
        XCTAssertEqual(message?.createdAt, dateFormatter(comment.createdAt))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        dateFormatter: @escaping (Date) -> String = { _ in "any" },
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
