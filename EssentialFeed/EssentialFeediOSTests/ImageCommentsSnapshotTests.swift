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

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "IMAGE_COMMENT_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "IMAGE_COMMENT_FEED_dark")
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
            storyboard.instantiateInitialViewController() as! ImageCommentsViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func emptyImageComments() -> [ImageCommentCellController] {
        return []
    }

    private func imageCommentsWithContent() -> [ImageCommentStub] {
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
            ImageCommentStub(
                username: "user a",
                message: String(repeating: "message", count: 100),
                createdAt: oneHourAgoString),
            ImageCommentStub(
                username: "user b",
                message: "This message is yesterday's",
                createdAt: yeasterdayString),
            ImageCommentStub(
                username: "user c",
                message: "This message is last week's",
                createdAt: lastWeekString),
            ImageCommentStub(
                username: "user d",
                message: "This message is last month's",
                createdAt: lastMonthString),
            ImageCommentStub(
                username: "user e",
                message: "This message is last year's",
                createdAt: lastYearString),
        ]
    }
}

extension ImageCommentsViewController {
    fileprivate func display(_ stubs: [ImageCommentStub]) {
        let cells: [ImageCommentCellController] = stubs.map { stub in
            let cellController = ImageCommentCellController(delegate: stub)
            stub.controller = cellController
            return cellController
        }

        self.display(cells)
    }
}

private class ImageCommentStub: ImageCommentCellControllerDelegate {
    let viewModel: ImageCommentViewModel
    weak var controller: ImageCommentCellController?

    init(username: String, message: String, createdAt: String) {
        viewModel = ImageCommentViewModel(id: UUID(), message: message,
                                          createdAt: createdAt, username: username)
    }

    func didRequestImageComment() {
        controller?.display(viewModel)
    }
}

private extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
