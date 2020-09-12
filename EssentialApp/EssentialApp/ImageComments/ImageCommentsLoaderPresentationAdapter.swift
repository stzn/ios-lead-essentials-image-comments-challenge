//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOS

final class ImageCommentsLoaderPresentationAdapter: ImageCommentsViewControllerDelegate {
    private let imageCommentsLoader: (UUID) -> AnyPublisher<[ImageComment], Swift.Error>
    private var cancellable: Cancellable?
    var presenter: ImageCommentsPresenter?

    init(imageCommentsLoader: @escaping (UUID) -> AnyPublisher<[ImageComment], Swift.Error>) {
        self.imageCommentsLoader = imageCommentsLoader
    }

    func didRequestImageCommentsRefresh(feedId: UUID) {
        presenter?.didStartLoadingView()

        cancellable = imageCommentsLoader(feedId)
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
