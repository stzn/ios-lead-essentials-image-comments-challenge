//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class FeedUIComposer {
    private init() {}

    private typealias FeedPresentationAdapter = LoaderPresentationAdapter<[FeedImage], FeedViewAdapter>
    private typealias FeedPresenter = Presenter<[FeedImage], FeedViewAdapter>


    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<[FeedImage], Swift.Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Swift.Error>
    ) -> FeedViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: feedLoader)

        let feedController = makeFeedViewController(
            delegate: presentationAdapter,
            title: FeedLocalizedString.title)

        presentationAdapter.presenter = FeedPresenter(
            view: FeedViewAdapter(
                controller: feedController,
                imageLoader: imageLoader),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedLocalizedString.map)

        return feedController
    }

    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}
