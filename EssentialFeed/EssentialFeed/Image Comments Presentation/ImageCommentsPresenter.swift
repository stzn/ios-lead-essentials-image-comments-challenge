//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public protocol ImageCommentsView {
    func display(_ viewModel: ImageCommentsViewModel)
}

public protocol ImageCommentsLoadingView {
    func display(_ viewModel: ImageCommentsLoadingViewModel)
}

public protocol ImageCommentsErrorView {
    func display(_ viewModel: ImageCommentsErrorViewModel)
}

public final class ImageCommentsPresenter {
    private let commentsView: ImageCommentsView
    private let loadingView: ImageCommentsLoadingView
    private let errorView: ImageCommentsErrorView

    private var commentsLoadError: String {
        return NSLocalizedString("COMMENTS_VIEW_CONNECTION_ERROR",
                tableName: "Comments",
                bundle: Bundle(for: ImageCommentsPresenter.self),
                comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(commentsView: ImageCommentsView, loadingView: ImageCommentsLoadingView, errorView: ImageCommentsErrorView) {
        self.commentsView = commentsView
        self.loadingView = loadingView
        self.errorView = errorView
    }

    public static var title: String {
        return NSLocalizedString("COMMENTS_VIEW_TITLE",
            tableName: "Comments",
            bundle: Bundle(for: ImageCommentsPresenter.self),
            comment: "Title for the feed view")
    }

    public func didStartLoadingImageComments() {
        errorView.display(.noError)
        loadingView.display(ImageCommentsLoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingImageComments(with comments: [ImageComment]) {
        commentsView.display(ImageCommentsViewModel(comments: comments))
        loadingView.display(ImageCommentsLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingImageComments(with error: Error) {
        errorView.display(.error(message: commentsLoadError))
        loadingView.display(ImageCommentsLoadingViewModel(isLoading: false))
    }
}
