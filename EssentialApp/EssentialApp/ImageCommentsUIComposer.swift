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
        imageCommentsLoader: @escaping () -> AnyPublisher<[ImageComment], Swift.Error>
    ) -> ImageCommentsViewController {
        let presentationAdapter = ImageCommentsLoaderPresentationAdapter(imageCommentsLoader: imageCommentsLoader)

        let imageCommentsController = makeImageCommentsViewController(
            delegate: presentationAdapter,
            title: ImageCommentsPresenter.title)

        presentationAdapter.presenter = Presenter(
            view: ImageCommentsViewAdapter(
                controller: imageCommentsController),
            loadingView: WeakRefVirtualProxy(imageCommentsController),
            errorView: WeakRefVirtualProxy(imageCommentsController))

        return imageCommentsController
    }

    private static func makeImageCommentsViewController(delegate: ImageCommentsViewControllerDelegate, title: String) -> ImageCommentsViewController {
        let bundle = Bundle(for: ImageCommentsViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let imageCommnetsController = storyboard.instantiateInitialViewController() as! ImageCommentsViewController
        imageCommnetsController.delegate = delegate
        imageCommnetsController.title = title
        return imageCommnetsController
    }
}
