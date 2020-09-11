//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentsLocalizedString {
    public static var title: String {
        return NSLocalizedString("VIEW_TITLE",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: Self.self),
                                 comment: "Title for the feed view")
    }
}

//public protocol ImageCommentsView {
//    func display(_ viewModel: ImageCommentsViewModel)
//}

//public final class ImageCommentsPresenter {
//    private let commentsView: ImageCommentsView
//    private let loadingView: LoadingView
//    private let errorView: ErrorView
//
//    public init(commentView: ImageCommentsView, loadingView: LoadingView, errorView: ErrorView) {
//        self.commentsView = commentView
//        self.loadingView = loadingView
//        self.errorView = errorView
//    }
//
//    public static var title: String {
//        return NSLocalizedString("VIEW_TITLE",
//                                 tableName: "ImageComments",
//                                 bundle: Bundle(for: ImageCommentsPresenter.self),
//                                 comment: "Title for the feed view")
//    }
//
//    public func didFinishLoadingImageComments(with comments: [ImageComment]) {
//        commentsView.display(ImageCommentsViewModel(comments: comments))
//        loadingView.display(LoadingViewModel(isLoading: false))
//    }
//}
