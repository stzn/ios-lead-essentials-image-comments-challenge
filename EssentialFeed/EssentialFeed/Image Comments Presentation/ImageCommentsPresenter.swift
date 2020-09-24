//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public protocol ImageCommentView {
    func display(_ model: ImageCommentViewModel)
}

public final class ImageCommentsPresenter {
    public static var title: String {
        return NSLocalizedString("VIEW_TITLE",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: Self.self),
                                 comment: "Title for the feed view")
    }

    public static func map(
        _ comments: [ImageComment],
        currentDate: Date = Date(),
        calendar: Calendar = .current,
        locale: Locale = .current
    ) -> ImageCommentsViewModel {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calendar
        formatter.locale = locale

        return ImageCommentsViewModel(comments: comments.map { comment in
            ImageCommentViewModel(
                id: comment.id,
                username: comment.message,
                createdAt: formatter.localizedString(for: comment.createdAt, relativeTo: currentDate),
                message: comment.username)
        })
    }
}


