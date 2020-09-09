//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
@testable import EssentialFeed

class ImageCommentViewModelMapperTests: XCTestCase {
    func test_map_imageCommentsToImageCommentViewModel() throws {
        let now = Date()

        let moreThanOneHourAgo = now.adding(seconds: -TimeInterval(60*60*1 + 1))
        let moreThanOneDayAgo = now.adding(seconds: -TimeInterval(60*60*24 + 1))
        let moreThanOneWeekAgo = now.adding(seconds: -TimeInterval(60*60*24*7 + 1))
        let moreThanOneMonthAgo = now.adding(seconds: -TimeInterval(60*60*24*31 + 1))
        let moreThanOneYearAgo = now.adding(seconds: -TimeInterval(60*60*24*31*12 + 1))
        let samples: [(ImageComment, String)] = [
            (makeComment(createdAt: moreThanOneHourAgo), "1 hour ago"),
            (makeComment(createdAt: moreThanOneDayAgo), "1 day ago"),
            (makeComment(createdAt: moreThanOneWeekAgo), "1 week ago"),
            (makeComment(createdAt: moreThanOneMonthAgo), "1 month ago"),
            (makeComment(createdAt: moreThanOneYearAgo), "1 year ago"),
        ]

        try samples.forEach { (comment, expectedDateString) in
            XCTAssertNoThrow(try ImageCommentViewModelMapper.map(comment))
            let viewModel = try! ImageCommentViewModelMapper.map(comment)
            XCTAssertEqual(viewModel.id, comment.id)
            XCTAssertEqual(viewModel.message, comment.message)
            XCTAssertEqual(viewModel.username, comment.username)
            XCTAssertEqual(viewModel.createdAt, expectedDateString)
        }
    }

    // MARK: - Helpers

    private func makeComment(
        message: String = "any message",
        createdAt: Date = Date(),
        username: String = "any username"
    ) -> ImageComment {
        return ImageComment(id: UUID(), message: message, createdAt: createdAt, username: username)
    }
}
