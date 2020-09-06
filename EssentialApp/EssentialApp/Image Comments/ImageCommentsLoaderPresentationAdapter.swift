//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import EssentialFeed
import EssentialFeediOS

final class ImageCommentsLoaderPresentationAdapter: ImageCommentsViewControllerDelegate {
    private let imageCommentsLoader: (FeedImage) -> AnyPublisher<[ImageComment], Swift.Error>
    private var cancellable: Cancellable?
    var presenter: Presenter<ImageCommentsViewAdapter>?
    
    init(imageCommentsLoader: @escaping (FeedImage) -> AnyPublisher<[ImageComment], Swift.Error>) {
        self.imageCommentsLoader = imageCommentsLoader
    }
    
    func didRequestImageCommentsRefresh(for feed: FeedImage) {
        presenter?.didStartLoading()
        
        cancellable = imageCommentsLoader(feed)
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break
                        
                    case let .failure(error):
                        self?.presenter?.didFinishLoading(with: error)
                    }
                }, receiveValue: { [weak self] comments in
                    self?.presenter?.didFinishLoadingImageComments(with: comments)
                })
    }
}
