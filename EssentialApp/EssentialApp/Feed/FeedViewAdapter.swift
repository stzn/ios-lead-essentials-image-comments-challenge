//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Combine
import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {
    private weak var controller: FeedViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Swift.Error>

    init(controller: FeedViewController, imageLoader: @escaping (URL) -> AnyPublisher<Data, Swift.Error>) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: [FeedImage]) {
        controller?.display(viewModel.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: self.imageLoader)
            let view = FeedImageCellController(delegate: adapter)
            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init)

            return view
        })
    }
}
