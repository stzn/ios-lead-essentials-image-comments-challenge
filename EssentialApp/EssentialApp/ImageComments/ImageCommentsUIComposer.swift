//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

typealias ImageCommentsPresenter = Presenter<ImageCommentsViewAdapter, [ImageComment]>

public final class ImageCommentsUIComposer {
    private init() {}

    public static func imageCommnetsComposedWith(
        feed: FeedImage,
        imageCommentsLoader: @escaping () -> AnyPublisher<[ImageComment], Swift.Error>
    ) -> ImageCommentsViewController {
        let presentationAdapter = ImageCommentsLoaderPresentationAdapter(imageCommentsLoader: imageCommentsLoader)

        let imageCommentsController = makeImageCommentsViewController(delegate: presentationAdapter)

        presentationAdapter.presenter = Presenter(
            view: ImageCommentsViewAdapter(
                controller: imageCommentsController,
                dateFormatter: { ImageCommentCreatedAtDateFormatter.format(from: $0) }),
            loadingView: WeakRefVirtualProxy(imageCommentsController),
            errorView: WeakRefVirtualProxy(imageCommentsController))

        return imageCommentsController
    }

    private static func makeImageCommentsViewController(
        delegate: ImageCommentsViewControllerDelegate) -> ImageCommentsViewController {
        let bundle = Bundle(for: ImageCommentsViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        guard let viewController = storyboard.instantiateInitialViewController() as? ImageCommentsViewController else {
            fatalError()
        }
        viewController.delegate = delegate
        viewController.title = ImageCommentsPresenter.title
        return viewController
    }
}
