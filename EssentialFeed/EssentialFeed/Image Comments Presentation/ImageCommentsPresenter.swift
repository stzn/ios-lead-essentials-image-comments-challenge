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

    public static func map(_ model: ImageComment, formatter: @escaping (Date) -> String) -> ImageCommentViewModel {
        ImageCommentViewModel(
            id: model.id,
            username: model.username,
            createdAt: formatter(model.createdAt),
            message: model.message)
    }
}

