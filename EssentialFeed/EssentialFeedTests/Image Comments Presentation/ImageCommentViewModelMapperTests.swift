//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentCreatedAtDateFormatterTests: XCTestCase {
    func test_format_dateToString() {
        let now = Date()

        let moreThanOneHourAgo = now.adding(seconds: -TimeInterval(60*60*1 + 1))
        let moreThanOneDayAgo = now.adding(seconds: -TimeInterval(60*60*24 + 1))
        let moreThanOneWeekAgo = now.adding(seconds: -TimeInterval(60*60*24*7 + 1))
        let moreThanOneMonthAgo = now.adding(seconds: -TimeInterval(60*60*24*31 + 1))
        let moreThanOneYearAgo = now.adding(seconds: -TimeInterval(60*60*24*31*12 + 1))
        let samples: [(Date, String)] = [
            (moreThanOneHourAgo, "1 hour ago"),
            (createdAt: moreThanOneDayAgo, "1 day ago"),
            (createdAt: moreThanOneWeekAgo, "1 week ago"),
            (createdAt: moreThanOneMonthAgo, "1 month ago"),
            (createdAt: moreThanOneYearAgo, "1 year ago"),
        ]

        samples.forEach { (date, expectedDateString) in
            XCTAssertEqual(expectedDateString, ImageCommentCreatedAtDateFormatter.format(from: date))
        }
    }
}
