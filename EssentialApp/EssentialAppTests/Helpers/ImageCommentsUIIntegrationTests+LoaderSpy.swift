//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOS

extension ImageCommentsUIIntegrationTests {

    class LoaderSpy {

        // MARK: - ImmageCommentsLoader

        typealias LoaderResult = Swift.Result<[ImageComment], Error>
        typealias LoaderPublisher = AnyPublisher<[ImageComment], Error>

        func loadPublisher() -> LoaderPublisher {
            Deferred {
                Future(self.load)
            }
            .eraseToAnyPublisher()
        }

        private var imageCommentRequests: [(LoaderResult) -> Void] = []

        var loadImageCommentsCallCount: Int {
            return imageCommentRequests.count
        }

        func load(completion: @escaping (LoaderResult) -> Void) {
            imageCommentRequests.append(completion)
        }

        func completeImageCommentsLoading(with comments: [ImageComment] = [], at index: Int = 0) {
            imageCommentRequests[index](.success(comments))
        }

        func completeImageCommentsLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageCommentRequests[index](.failure(error))
        }

    }

}
