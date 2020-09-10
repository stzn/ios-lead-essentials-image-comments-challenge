//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public protocol ImageCommentView {
    func display(_ model: ImageCommentViewModel)
}

public final class ImageCommentPresenter<View: ImageCommentView> {
    private let view: View
    private let dateFormatter: (Date) -> String

    public init(view: View, dateFormatter: @escaping (Date) -> String) {
        self.view = view
        self.dateFormatter = dateFormatter
    }

    public func didFinishLoadingImageComment(for model: ImageComment) {
        view.display(ImageCommentViewModel(id: model.id,
                                           message: model.message,
                                           createdAt: dateFormatter(model.createdAt),
                                           username: model.username))
    }
}
