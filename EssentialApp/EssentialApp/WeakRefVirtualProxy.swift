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

extension WeakRefVirtualProxy: ErrorView where T: ErrorView {
    func display(_ viewModel: ErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: LoadingView where T: LoadingView {
    func display(_ viewModel: LoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ResourceView where T: ResourceView, T.ResourceViewModel == UIImage {
    func display(_ model: UIImage) {
        object?.display(model)
    }
}

extension WeakRefVirtualProxy: ImageCommentView where T: ImageCommentView {
    func display(_ viewModel: ImageCommentViewModel) {
        object?.display(viewModel)
    }
}
