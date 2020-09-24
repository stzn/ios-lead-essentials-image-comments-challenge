//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class ImageCommentsUIComposer {
    private init() {}

    private typealias ImageCommentsPresentationAdapter = LoaderPresentationAdapter<[ImageComment], ImageCommentsViewAdapter>
    public static func imageCommnetsComposedWith(
        feedId: UUID,
        imageCommentsLoader: @escaping () -> AnyPublisher<[ImageComment], Swift.Error>
    ) -> ImageCommentsViewController {
        let presentationAdapter = ImageCommentsPresentationAdapter(loader: imageCommentsLoader)

        let imageCommentsController = makeImageCommentsViewController(
            feedId: feedId, delegate: presentationAdapter)

        presentationAdapter.presenter = Presenter<[ImageComment], ImageCommentsViewAdapter>(
            view: ImageCommentsViewAdapter(
                controller: imageCommentsController,
                dateFormatter: { ImageCommentCreatedAtDateFormatter.format(from: $0) }),
            loadingView: WeakRefVirtualProxy(imageCommentsController),
            errorView: WeakRefVirtualProxy(imageCommentsController),
            mapper: { ImageCommentsPresenter.map($0) })

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
        viewController.title = ImageCommentsPresenter.title
        return viewController
    }
}
