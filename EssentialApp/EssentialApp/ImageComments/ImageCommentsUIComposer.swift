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
        viewController.configureNavigationBar()
        viewController.title = ImageCommentsPresenter.title
        return viewController
    }
}

// MARK: - NavigationBar

private extension ListViewController {
    func configureNavigationBar() {
        navigationItem.standardAppearance = navigatioBarAppearance
        navigationController?.navigationBar.tintColor = .secondaryLabel
    }

    var navigatioBarAppearance: UINavigationBarAppearance {
        let standard = UINavigationBarAppearance()
        standard.configureWithTransparentBackground()
        standard.backgroundImage = UIImage()
        standard.shadowImage = UIImage()
        standard.backButtonAppearance = barButtionItemAppearance
        return standard
    }

    var barButtionItemAppearance: UIBarButtonItemAppearance {
        let button = UIBarButtonItemAppearance(style: .plain)
        button.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
        return button
    }
}
