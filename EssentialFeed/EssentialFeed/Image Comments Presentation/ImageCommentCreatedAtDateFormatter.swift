//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentCreatedAtDateFormatter {
    private static var formatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        return formatter
    }()

    public static func format(from date: Date, relativeTo standard: Date = Date()) -> String {
        formatter.localizedString(for: date, relativeTo: standard)
    }
}
