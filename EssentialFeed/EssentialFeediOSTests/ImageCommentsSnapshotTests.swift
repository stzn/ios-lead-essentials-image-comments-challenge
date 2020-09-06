//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeediOS
import XCTest

@testable import EssentialFeed

class ImageCommentsSnapshotTests: XCTestCase {

    func test_emptyFeed() {
        let sut = makeSUT()

        sut.display(emptyImageComment())

        assert(
            snapshot: sut.snapshot(for: .iPhone8(style: .light)),
            named: "EMPTY_IMAGE_COMMENTS_light")
        assert(
            snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_IMAGE_COMMENTS_dark")
    }

    func test_imageCommentWithContent() {
        let sut = makeSUT()

        sut.display(imageCommentWithContent())

        assert(
            snapshot: sut.snapshot(for: .iPhone8(style: .light)),
            named: "IMAGE_COMMENTS_WITH_CONTENT_light")
        assert(
            snapshot: sut.snapshot(for: .iPhone8(style: .dark)),
            named: "IMAGE_COMMENTS_WITH_CONTENT_dark")
    }

    func test_feedWithErrorMessage() {
        let sut = makeSUT()

        sut.display(.error(message: "This is a\nmulti-line\nerror message"))

        assert(
            snapshot: sut.snapshot(for: .iPhone8(style: .light)),
            named: "IMAGE_COMMENTS_WITH_ERROR_MESSAGE_light")
        assert(
            snapshot: sut.snapshot(for: .iPhone8(style: .dark)),
            named: "IMAGE_COMMENTS_WITH_ERROR_MESSAGE_dark")
    }

    // MARK: - Helpers

    private func makeSUT() -> ImageCommentsViewController {
        let bundle = Bundle(for: ImageCommentsViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let imageCommnetsController = storyboard.instantiateInitialViewController { coder in
            ImageCommentsViewController(coder: coder, feed: self.uniqueFeed,
                                        title: ImageCommentsPresenter.titleKey, delegate: ImageCommentsStub())
        }

        guard let controller = imageCommnetsController else {
            fatalError()
        }
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func emptyImageComment() -> [ImageCommentCellController] {
        return []
    }

    private func imageCommentWithContent() -> [ImageCommentStub] {
        let now = Date()

        let oneDayInterval: TimeInterval = 60 * 60 * 24
        let oneWeekInterval: TimeInterval = oneDayInterval * 7
        let aboutOneMonthInterval: TimeInterval = oneWeekInterval * 5
        let aboutOneYearInterval: TimeInterval = aboutOneMonthInterval * 12

        let yeasterdayString = ImageCommentDateFormatter.format(
            from: now.adding(seconds: -oneDayInterval - 1))
        let lastWeekString = ImageCommentDateFormatter.format(
            from: now.adding(seconds: -oneWeekInterval - 1))
        let lastMonthString = ImageCommentDateFormatter.format(
            from: now.adding(seconds: -aboutOneMonthInterval - 1))
        let lastYearString = ImageCommentDateFormatter.format(
            from: now.adding(seconds: -aboutOneYearInterval - 1))

        return [
            ImageCommentStub(
                username: "user a",
                message: "message a",
                createdAt: yeasterdayString),
            ImageCommentStub(
                username: "user b",
                message: "message b",
                createdAt: lastWeekString),
            ImageCommentStub(
                username: "user c",
                message: "message c",
                createdAt: lastMonthString),
            ImageCommentStub(
                username: "user d",
                message: "message d",
                createdAt: lastYearString),
        ]
    }

    private var uniqueFeed: FeedImage {
        FeedImage(id: UUID(), description: "any", location: "any", url: anyURL)
    }

    private var anyURL: URL {
        URL(string: "http://any-url.com")!
    }
}

extension ImageCommentsViewController {
    fileprivate func display(_ stubs: [ImageCommentStub]) {
        let cells: [ImageCommentCellController] = stubs.map { stub in
            let cellController = ImageCommentCellController(delegate: stub)
            stub.controller = cellController
            return cellController
        }

        display(cells)
    }
}

private class ImageCommentStub: ImageCommentCellControllerDelegate {
    let viewModel: ImageCommentViewModel
    weak var controller: ImageCommentCellController?

    init(username: String, message: String, createdAt: String) {
        viewModel = ImageCommentViewModel(
            username: username,
            message: message,
            createdAt: createdAt)
    }

    func didRequestImageComment() {
        controller?.display(viewModel)
    }
}

private class ImageCommentsStub: ImageCommentsViewControllerDelegate {
    func didRequestImageCommentsRefresh(for feed: FeedImage) {
    }
}

extension Date {
    fileprivate func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
