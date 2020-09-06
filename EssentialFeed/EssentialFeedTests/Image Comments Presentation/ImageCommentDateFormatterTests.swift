//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentDateFormatterTests: XCTestCase {
    func test() {
        typealias TestCase = (line: UInt, testDate: Date, expected: String)

        let oneDayInterval: TimeInterval = 60 * 60 * 24
        let oneWeekInterval: TimeInterval = oneDayInterval * 7
        let aboutOneMonthInterval: TimeInterval = oneWeekInterval * 5
        let aboutOneYearInterval: TimeInterval = aboutOneMonthInterval * 12

        let now = Date()
        let testCases: [TestCase] = [
            (#line, now.adding(seconds: -oneDayInterval - 1), "1 day ago"),
            (#line, now.adding(seconds: -oneWeekInterval - 1), "1 week ago"),
            (#line, now.adding(seconds: -aboutOneMonthInterval - 1), "1 month ago"),
            (#line, now.adding(seconds: -aboutOneYearInterval - 1), "1 year ago"),
        ]

        for testCase in testCases {
            let (line, testDate, expected) = testCase
            XCTAssertEqual(ImageCommentDateFormatter.format(from: testDate, relativeTo: now), expected, line: line)
        }
    }
}
