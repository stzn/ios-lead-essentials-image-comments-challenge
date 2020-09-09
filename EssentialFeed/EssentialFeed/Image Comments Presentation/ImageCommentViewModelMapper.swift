//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

final class ImageCommentViewModelMapper {
    static func map(
        _ comment: ImageComment,
        formatter: @escaping (Date) throws -> String = {
            CreatedAtDateFormatter.format(from: $0, relativeTo: Date())
        }
    ) throws -> ImageCommentViewModel {
        ImageCommentViewModel(
            id: comment.id,
            message: comment.message,
            createdAt: try formatter(comment.createdAt),
            username: comment.username)
    }

    final class CreatedAtDateFormatter {
        private static var formatter: RelativeDateTimeFormatter = {
            let formatter = RelativeDateTimeFormatter()
            return formatter
        }()

        static func format(from date: Date, relativeTo standard: Date = Date()) -> String {
            formatter.localizedString(for: date, relativeTo: standard)
        }
    }
}

