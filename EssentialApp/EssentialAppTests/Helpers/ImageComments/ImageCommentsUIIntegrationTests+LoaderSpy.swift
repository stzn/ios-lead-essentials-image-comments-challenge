//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import EssentialFeed
import EssentialFeediOS
import Foundation

extension ImageCommentsUIIntegrationTests {

  class LoaderSpy {

    // MARK: - ImageCommentsLoader

    typealias ImageCommentsLoaderResult = Swift.Result<[ImageComment], Error>
    typealias ImageCommentsLoaderPublisher = AnyPublisher<[ImageComment], Error>

    func loadPublisher(_ feedId: UUID) -> ImageCommentsLoaderPublisher {
      Deferred {
        Future(self.load)
      }
      .eraseToAnyPublisher()
    }

    private var imageCommentsRequests: [(ImageCommentsLoaderResult) -> Void] = []

    var loadImageCommentsCallCount: Int {
      return imageCommentsRequests.count
    }

    func load(completion: @escaping (ImageCommentsLoaderResult) -> Void) {
      imageCommentsRequests.append(completion)
    }

    func completeImageCommentsLoading(with feed: [ImageComment] = [], at index: Int = 0) {
      imageCommentsRequests[index](.success(feed))
    }

    func completeImageCommentsLoadingWithError(at index: Int = 0) {
      let error = NSError(domain: "an error", code: 0)
      imageCommentsRequests[index](.failure(error))
    }
  }
}
