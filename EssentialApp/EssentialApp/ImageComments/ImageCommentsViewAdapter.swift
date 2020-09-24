//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import EssentialFeed
import EssentialFeediOS
import UIKit

final class ImageCommentsViewAdapter: ResourceView {
    typealias Content = [ImageComment]

    private weak var controller: ImageCommentsViewController?
    private let dateFormatter: (Date) -> String

    init(controller: ImageCommentsViewController, dateFormatter: @escaping (Date) -> String) {
        self.controller = controller
        self.dateFormatter = dateFormatter
    }

    func display(_ viewModel: ViewModel<[ImageComment]>) {
        controller?.display(
            viewModel.content.map { model in
                let view = ImageCommentCellController(
                    viewModel: ImageCommentsPresenter.map(model, formatter: dateFormatter)
                )
                return view
            })
    }
}
