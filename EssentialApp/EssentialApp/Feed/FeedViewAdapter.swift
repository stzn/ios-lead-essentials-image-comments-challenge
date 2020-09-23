//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Combine
import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: View {
    typealias Content = [FeedImage]

    private weak var controller: FeedViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Swift.Error>

    init(controller: FeedViewController, imageLoader: @escaping (URL) -> AnyPublisher<Data, Swift.Error>) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: ViewModel<[FeedImage]>) {
        controller?.display(viewModel.content.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: self.imageLoader)
            let view = FeedImageCellController(delegate: adapter)
            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init)

            return view
        })
    }
}
