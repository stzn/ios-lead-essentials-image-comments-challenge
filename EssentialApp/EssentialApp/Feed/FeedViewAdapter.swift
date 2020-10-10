//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Combine
import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Swift.Error>
    private let selection: (FeedImage) -> Void
    typealias FeedImageDataLoaderPresentationAdapter = LoaderPresentationAdapter<Data, WeakRefVirtualProxy<FeedImageCellController>>

    init(controller: ListViewController, imageLoader: @escaping (URL) -> AnyPublisher<Data, Swift.Error>,
         selection: @escaping (FeedImage) -> Void) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }

    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter(loader: { [imageLoader] in imageLoader(model.url) })
            let view = FeedImageCellController(viewModel: FeedImagePresenter.map(model), delegate: adapter,
                                               selection: { [selection] in selection(model) })
            adapter.presenter = Presenter(
                view: WeakRefVirtualProxy(view),
                loadingView: WeakRefVirtualProxy(view),
                errorView: WeakRefVirtualProxy(view),
                mapper: UIImage.tryMap)

            return CellController(id: model.id, dataSoruce: view, delegate: view, prefetchDataSource: view)
        })
    }
}

extension UIImage {
    struct InvalidData: Error {}

    static func tryMap(_ data: Data) throws -> UIImage {
        if let image = UIImage(data: data) {
            return image
        } else {
            throw InvalidData()
        }
    }
}
