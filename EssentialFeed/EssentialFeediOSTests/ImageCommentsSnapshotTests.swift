//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeediOS
import XCTest

@testable import EssentialFeed

class ImageCommentsSnapshotTests: XCTestCase {

    func test_emptyImageComments() {
        let sut = makeSUT()

        sut.display(emptyImageComments())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_IMAGE_COMMENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_IMAGE_COMMENT_dark")
    }

    func test_imageCommentsWithContent() {
        let sut = makeSUT()

        sut.display(imageCommentsWithContent())

        assert(
            snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "IMAGE_COMMENT_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "IMAGE_COMMENT_WITH_CONTENT_dark")
    }

    func test_imageCommentsWithErrorMessage() {
        let sut = makeSUT()

        sut.display(.error(message: "This is a\nmulti-line\nerror message"))

        assert(
            snapshot: sut.snapshot(for: .iPhone8(style: .light)),
            named: "IMAGE_COMMENT_WITH_ERROR_MESSAGE_light")
        assert(
            snapshot: sut.snapshot(for: .iPhone8(style: .dark)),
            named: "IMAGE_COMMENT_WITH_ERROR_MESSAGE_dark")
    }

    // MARK: - Helpers

    private func makeSUT() -> ImageCommentsViewController {
        let bundle = Bundle(for: ImageCommentsViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller =
            storyboard.instantiateInitialViewController { coder in
                ImageCommentsViewController(coder: coder, feedId: UUID())
            }!
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func emptyImageComments() -> [ImageCommentCellController] {
        return []
    }

    private func imageCommentsWithContent() -> [ImageCommentViewModel] {
        let now = Date()

        let moreThanOneHourAgo = now.adding(seconds: -TimeInterval(60*60*1 + 1))
        let moreThanOneDayAgo = now.adding(seconds: -TimeInterval(60*60*24 + 1))
        let moreThanOneWeekAgo = now.adding(seconds: -TimeInterval(60*60*24*7 + 1))
        let moreThanOneMonthAgo = now.adding(seconds: -TimeInterval(60*60*24*31 + 1))
        let moreThanOneYearAgo = now.adding(seconds: -TimeInterval(60*60*24*31*12 + 1))

        let oneHourAgoString = ImageCommentCreatedAtDateFormatter.format(
            from: moreThanOneHourAgo)
        let yeasterdayString = ImageCommentCreatedAtDateFormatter.format(
            from: moreThanOneDayAgo)
        let lastWeekString = ImageCommentCreatedAtDateFormatter.format(
            from: moreThanOneWeekAgo)
        let lastMonthString = ImageCommentCreatedAtDateFormatter.format(
            from: moreThanOneMonthAgo)
        let lastYearString = ImageCommentCreatedAtDateFormatter.format(
            from: moreThanOneYearAgo)

        return [
            ImageCommentViewModel(
                id: UUID(),
                username: "user a",
                createdAt: oneHourAgoString,
                message: String(repeating: "message", count: 100)
            ),
            ImageCommentViewModel(
                id: UUID(),
                username: "user b",
                createdAt: yeasterdayString,
                message: "This message is yesterday's"
            ),
            ImageCommentViewModel(
                id: UUID(),
                username: "user c",
                createdAt: lastWeekString,
                message: "This message is last week's"
            ),
            ImageCommentViewModel(
                id: UUID(),
                username: "user d",
                createdAt: lastMonthString,
                message: "This message is last month's"
            ),
            ImageCommentViewModel(
                id: UUID(),
                username: "user e",
                createdAt: lastYearString,
                message: "This message is last year's"
            )
        ]
    }
}

extension ImageCommentsViewController {
    fileprivate func display(_ viewModels: [ImageCommentViewModel]) {
        let cells: [ImageCommentCellController] = viewModels.map { viewModel in
            return ImageCommentCellController(viewModel: viewModel)
        }

        self.display(cells)
    }
}

private extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
