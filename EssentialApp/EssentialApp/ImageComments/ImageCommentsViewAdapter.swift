//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import EssentialFeed
import EssentialFeediOS
import UIKit

final class ImageCommentsViewAdapter: ResourceView {
    private weak var controller: ListViewController?

    init(controller: ListViewController) {
        self.controller = controller
    }

    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(
            viewModel.comments
                .map {
                    CellController(id: $0.id, dataSoruce: ImageCommentCellController.init(viewModel: $0))
                }
        )
    }
}
