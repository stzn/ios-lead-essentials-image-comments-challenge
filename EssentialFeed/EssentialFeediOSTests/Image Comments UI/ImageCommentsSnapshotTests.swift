//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeediOS
import XCTest

@testable import EssentialFeed

class ImageCommentsSnapshotTests: XCTestCase {

    func test_imageCommentsWithContent() {
        let sut = makeSUT()

        sut.display(comments())

        assert(
            snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "IMAGE_COMMENT_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "IMAGE_COMMENT_WITH_CONTENT_dark")
    }

    // MARK: - Helpers

    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func comments() -> [CellController] {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")

        let comments = [
            ImageComment(
                id: UUID(),
                message: String(repeating: "message", count: 100),
                createdAt: now.adding(hours: -1, calendar: calendar),
                username: "user a"),
            ImageComment(
                id: UUID(),
                message: "This message was sent yesterday",
                createdAt: now.adding(days: -1, calendar: calendar),
                username: "user b"),
            ImageComment(
                id: UUID(),
                message: "This message was sent last week",
                createdAt: now.adding(weeks: -1, calendar: calendar),
                username: "user c"),
            ImageComment(
                id: UUID(),
                message: "This message was sent last month",
                createdAt: now.adding(days: -31, calendar: calendar),
                username: "user d"),
            ImageComment(
                id: UUID(),
                message: "This message was sent last year",
                createdAt: now.adding(years: -1, calendar: calendar),
                username: "user e"),
            ImageComment(
                id: UUID(),
                message: "This message was sent one minute ago",
                createdAt: now.adding(minutes: -1, calendar: calendar),
                username: "user f"),
        ]

        return ImageCommentsPresenter
            .map(comments, calendar: calendar, locale: locale).comments
            .map {
                CellController(id: UUID(), dataSoruce: ImageCommentCellController.init(viewModel: $0))
            }
    }
}


extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }

    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self)!
    }

    func adding(hours: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .hour, value: hours, to: self)!
    }

    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }

    func adding(weeks: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .weekOfMonth, value: weeks, to: self)!
    }

    func adding(months: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .month, value: months, to: self)!
    }

    func adding(years: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .year, value: years, to: self)!
    }
}
