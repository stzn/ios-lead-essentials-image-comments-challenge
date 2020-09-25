//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import EssentialFeed
import EssentialFeediOS
import UIKit

final class ImageCommentsViewAdapter: ResourceView {
    private weak var controller: ImageCommentsViewController?

    init(controller: ImageCommentsViewController) {
        self.controller = controller
    }

    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(
            viewModel.comments.map(ImageCommentCellController.init))
    }
}
