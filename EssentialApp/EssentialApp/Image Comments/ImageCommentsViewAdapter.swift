//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import UIKit
import EssentialFeed
import EssentialFeediOS

final class ImageCommentsViewAdapter: ViewPresenter {
    private weak var controller: ImageCommentsViewController?
    
    init(controller: ImageCommentsViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { model in
            let adapter = ImageCommentPresentationAdapter<WeakRefVirtualProxy<ImageCommentCellController>>(model: model)
            let view = ImageCommentCellController(delegate: adapter)
            adapter.presenter = ImageCommentPresenter(
                view: WeakRefVirtualProxy(view),
                dateFormatter: { ImageCommentDateFormatter.format(from: $0) })
            return view
        })
    }
}
