//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentsLocalizedString {
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: Self.self),
                                 comment: "Title for the feed view")
    }
}

public protocol ImageCommentsView {
    func display(_ viewModel: ImageCommentsViewModel)
}

public final class ImageCommentsPresenter {
    private let commentsView: ImageCommentsView
    private let loadingView: LoadingView
    private let errorView: ErrorView

    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: ImageCommentsPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(commentView: ImageCommentsView, loadingView: LoadingView, errorView: ErrorView) {
        self.commentsView = commentView
        self.loadingView = loadingView
        self.errorView = errorView
    }

    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: ImageCommentsPresenter.self),
                                 comment: "Title for the feed view")
    }

    public func didStartLoadingImageComments() {
        errorView.display(.noError)
        loadingView.display(LoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingImageComments(with comments: [ImageComment]) {
        commentsView.display(ImageCommentsViewModel(comments: comments))
        loadingView.display(LoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingImageComments(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(LoadingViewModel(isLoading: false))
    }
}
