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
    private let feedView: ImageCommentsView
    private let loadingView: ImageCommentsLoadingView
    private let errorView: ImageCommentsErrorView

    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: ImageCommentsPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(feedView: ImageCommentsView, loadingView: ImageCommentsLoadingView, errorView: ImageCommentsErrorView) {
        self.feedView = feedView
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
        loadingView.display(ImageCommentsLoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingImageComments(with comments: [ImageComment]) {
        feedView.display(ImageCommentsViewModel(comments: comments))
        loadingView.display(ImageCommentsLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingImageComments(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(ImageCommentsLoadingViewModel(isLoading: false))
    }
}
