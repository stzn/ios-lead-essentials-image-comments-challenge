//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest

import XCTest
import EssentialFeed
import EssentialFeediOS

extension ImageCommentsUIIntegrationTests {
    
    func assertThat(_ sut: ImageCommentsViewController, isRendering comments: [ImageComment], file: StaticString = #file, line: UInt = #line) {
        sut.view.enforceLayoutCycle()
        
        guard sut.numberOfRenderedImageCommentViews() == comments.count else {
            return XCTFail("Expected \(comments.count) comments, got \(sut.numberOfRenderedImageCommentViews()) instead.", file: file, line: line)
        }
        
        comments.enumerated().forEach { index, comment in
            assertThat(sut, hasViewConfiguredFor: comment, at: index, file: file, line: line)
        }
    }
    
    func assertThat(_ sut: ImageCommentsViewController, hasViewConfiguredFor comment: ImageComment, at index: Int,
                    file: StaticString = #file, line: UInt = #line) {
        let view = sut.imageCommentView(at: index)
        
        guard let cell = view as? ImageCommentCell else {
            return XCTFail("Expected \(ImageCommentCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.usernameText, comment.username, "Expected `username` to be \(comment.username) for comment view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.messageText, comment.message, "Expected `message` to be \(comment.username) for comment view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(
            cell.createdAtText,
            ImageCommentDateFormatter.format(from: comment.createdAt),
            "Expected `createdAt` to be \(comment.createdAt) for comment view at index (\(index))",
            file: file, line: line)
    }
    
}
