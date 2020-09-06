//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public protocol ImageCommentView {
    func display(_ viewModel: ImageCommentViewModel)
}

public final class ImageCommentPresenter<View: ImageCommentView> {
    private let view: View
    let dateFormatter: (Date) -> String

    public init(view: View, dateFormatter: @escaping (Date) -> String) {
        self.view = view
        self.dateFormatter = dateFormatter
    }

    public func didFinishLoadingComment(with model: ImageComment) {
        view.display(ImageCommentViewModel(username: model.username, message: model.message,
                                           createdAt: dateFormatter(model.createdAt)))
    }
}
