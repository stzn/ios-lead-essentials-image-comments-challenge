//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class ImageCommentsUIComposer {
    private init() {}

    public static func imageCommnetsComposedWith(
        feed: FeedImage,
        imageCommentsLoader: @escaping (FeedImage) -> AnyPublisher<[ImageComment], Swift.Error>
    ) -> ImageCommentsViewController {
        let presentationAdapter = ImageCommentsLoaderPresentationAdapter(imageCommentsLoader: imageCommentsLoader)

        let imageCommentsController = makeImageCommentsViewController(
            feed: feed,
            title: ImageCommentsPresenter.title,
            delegate: presentationAdapter)

        presentationAdapter.presenter = Presenter(
            view: ImageCommentsViewAdapter(
                controller: imageCommentsController),
            loadingView: WeakRefVirtualProxy(imageCommentsController),
            errorView: WeakRefVirtualProxy(imageCommentsController))

        return imageCommentsController
    }

    private static func makeImageCommentsViewController(
        feed: FeedImage, title: String, delegate: ImageCommentsViewControllerDelegate) -> ImageCommentsViewController {
        let bundle = Bundle(for: ImageCommentsViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let imageCommnetsController = storyboard.instantiateInitialViewController { coder in
            ImageCommentsViewController(coder: coder, feed: feed, title: title, delegate: delegate)
        }

        guard let viewController = imageCommnetsController else {
            fatalError()
        }
        viewController.title = title
        return viewController
    }
}
