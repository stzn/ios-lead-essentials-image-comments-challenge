//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import EssentialFeed
import EssentialFeediOS

final class ImageCommentsLoaderPresentationAdapter: ImageCommentsViewControllerDelegate {
    private let imageCommentsLoader: () -> AnyPublisher<[ImageComment], Swift.Error>
    private var cancellable: Cancellable?
    var presenter: ImageCommentsPresenter?

    init(imageCommentsLoader: @escaping () -> AnyPublisher<[ImageComment], Swift.Error>) {
        self.imageCommentsLoader = imageCommentsLoader
    }

    func didRequestImageCommentsRefresh() {
        presenter?.didStartLoadingView()

        cancellable = imageCommentsLoader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break

                    case let .failure(error):
                        self?.presenter?.didFinishLoadingView(with: error)
                    }
                }, receiveValue: { [weak self] comments in
                    self?.presenter?.didFinishLoadingView(with: comments)
            })
    }
}
