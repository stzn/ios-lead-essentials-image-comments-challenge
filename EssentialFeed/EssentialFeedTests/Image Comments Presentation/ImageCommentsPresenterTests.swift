//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsPresenterTests: XCTestCase {

    func test_title_isLocalized() {
        XCTAssertEqual(ImageCommentsPresenter.title, localized("VIEW_TITLE"))
    }

    func test_map_createsViewModels() {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")

        let id1 = UUID()
        let id2 = UUID()
        let comments = [
            ImageComment(
                id: id1,
                message: "a message",
                createdAt: now.adding(minutes: -5, calendar: calendar),
                username: "a username"),
            ImageComment(
                id: id2,
                message: "another message",
                createdAt: now.adding(days: -1, calendar: calendar),
                username: "another username")
        ]

        let viewModel = ImageCommentsPresenter.map(
            comments,
            currentDate: now,
            calendar: calendar,
            locale: locale
        )

        XCTAssertEqual(viewModel.comments, [
            ImageCommentViewModel(
                id: id1,
                username: "a username",
                createdAt: "5 minutes ago", message: "a message"
            ),
            ImageCommentViewModel(
                id: id2,
                username: "another username",
                createdAt: "1 day ago", message: "another message"
            )
        ])
    }

    // MARK: - Helpers

    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
