//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ErrorViewPresenter where T: ErrorViewPresenter {
    func display(_ viewModel: ErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: LoadingViewPresenter where T: LoadingViewPresenter {
    func display(_ viewModel: LoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    func display(_ model: FeedImageViewModel<UIImage>) {
        object?.display(model)
    }
}

extension WeakRefVirtualProxy: ImageCommentView where T: ImageCommentView {
    func display(_ viewModel: ImageCommentViewModel) {
        object?.display(viewModel)
    }
}
