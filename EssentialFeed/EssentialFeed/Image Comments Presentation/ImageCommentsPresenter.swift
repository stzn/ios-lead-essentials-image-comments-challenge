//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentsPresenter {
    public static let stringsFileName = "Comments"
    public static let titleKey = "VIEW_TITLE"
    public static var title: String {
        return NSLocalizedString(titleKey,
            tableName: stringsFileName,
            bundle: Bundle(for: ImageCommentsPresenter.self),
            comment: "Title for the comments view")
    }
}

extension Presenter where V.ViewModel == ImageCommentsViewModel {
    public func didFinishLoadingImageComments(with comments: [ImageComment]) {
        didFinishLoading(with: ImageCommentsViewModel(comments: comments))
    }
}
