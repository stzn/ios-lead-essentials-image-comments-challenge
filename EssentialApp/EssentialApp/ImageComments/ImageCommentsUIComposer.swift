//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

typealias ImageCommentsPresenter = Presenter<ImageCommentsViewAdapter, [ImageComment]>

public final class ImageCommentsUIComposer {
    private init() {}

    public static func imageCommnetsComposedWith(
        feedId: UUID,
        imageCommentsLoader: @escaping (UUID) -> AnyPublisher<[ImageComment], Swift.Error>
    ) -> ImageCommentsViewController {
        let presentationAdapter = ImageCommentsLoaderPresentationAdapter(imageCommentsLoader: imageCommentsLoader)

        let imageCommentsController = makeImageCommentsViewController(
            feedId: feedId, delegate: presentationAdapter)

        presentationAdapter.presenter = Presenter(
            view: ImageCommentsViewAdapter(
                controller: imageCommentsController,
                dateFormatter: { ImageCommentCreatedAtDateFormatter.format(from: $0) }),
            loadingView: WeakRefVirtualProxy(imageCommentsController),
            errorView: WeakRefVirtualProxy(imageCommentsController))

        return imageCommentsController
    }

    private static func makeImageCommentsViewController(
        feedId: UUID,
        delegate: ImageCommentsViewControllerDelegate) -> ImageCommentsViewController {
        let bundle = Bundle(for: ImageCommentsViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)

        guard let viewController =
            (storyboard.instantiateInitialViewController { coder in
                ImageCommentsViewController(coder: coder, feedId: feedId)
            }) else {
                fatalError()
        }
        viewController.delegate = delegate
        viewController.title = ImageCommentsLocalizedString.title
        return viewController
    }
}
