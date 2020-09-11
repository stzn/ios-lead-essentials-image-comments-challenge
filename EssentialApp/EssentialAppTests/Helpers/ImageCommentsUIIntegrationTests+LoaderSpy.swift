//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOS

extension ImageCommentsUIIntegrationTests {

    class LoaderSpy {

        // MARK: - FeedLoader

        typealias FeedLoaderResult = Swift.Result<[FeedImage], Error>
        typealias FeedLoaderPublisher = AnyPublisher<[FeedImage], Error>

        func loadPublisher() -> FeedLoaderPublisher {
            Deferred {
                Future(self.load)
            }
            .eraseToAnyPublisher()
        }

        private var feedRequests: [(FeedLoaderResult) -> Void] = []

        var loadFeedCallCount: Int {
            return feedRequests.count
        }

        func load(completion: @escaping (FeedLoaderResult) -> Void) {
            feedRequests.append(completion)
        }

        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            feedRequests[index](.success(feed))
        }

        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            feedRequests[index](.failure(error))
        }

        // MARK: - FeedImageDataLoader

        typealias FeedImageDataLoaderResult = Swift.Result<Data, Error>
        typealias FeedImageDataLoaderPublisher = AnyPublisher<Data, Error>

        func loadImageDataPublisher(from url: URL) -> FeedImageDataLoaderPublisher {
            var task: FeedImageDataLoaderTask?

            return Deferred {
                Future { completion in
                    task = self.loadImageData(from: url, completion: completion)
                }
            }
            .handleEvents(receiveCancel: { task?.cancel() })
            .eraseToAnyPublisher()
        }

        private struct TaskSpy: FeedImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }

        private var imageRequests = [(url: URL, completion: (FeedImageDataLoaderResult) -> Void)]()

        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }

        private(set) var cancelledImageURLs = [URL]()

        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderResult) -> Void) -> FeedImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }

        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }

        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }

}
