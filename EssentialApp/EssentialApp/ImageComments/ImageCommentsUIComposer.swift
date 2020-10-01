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
        imageCommentsLoader: @escaping () -> AnyPublisher<[ImageComment], Swift.Error>
    ) -> ListViewController {
        let presentationAdapter = ImageCommentsPresentationAdapter(loader: imageCommentsLoader)

        let imageCommentsController = makeImageCommentsViewController()
        imageCommentsController.onRefresh = presentationAdapter.loadContent

        presentationAdapter.presenter = Presenter<[ImageComment], ImageCommentsViewAdapter>(
            view: ImageCommentsViewAdapter(controller: imageCommentsController),
            loadingView: WeakRefVirtualProxy(imageCommentsController),
            errorView: WeakRefVirtualProxy(imageCommentsController),
            mapper: { ImageCommentsPresenter.map($0) })

        return imageCommentsController
    }

    private static func makeImageCommentsViewController() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let viewController = storyboard.instantiateInitialViewController() as! ListViewController
        viewController.title = ImageCommentsPresenter.title
        return viewController
    }
}
