//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public protocol View {
    associatedtype Content

    func display(_ viewModel: ViewModel<Content>)
}

public protocol LoadingView {
    func display(_ viewModel: LoadingViewModel)
}

public protocol ErrorView {
    func display(_ viewModel: ErrorViewModel)
}

public final class Presenter<V: View, Content> where Content == V.Content {
    private let view: V
    private let loadingView: LoadingView
    private let errorView: ErrorView

    private var loadError: String {
        return NSLocalizedString("VIEW_CONNECTION_ERROR",
                                 tableName: "Shared",
                                 bundle: Bundle(for: Presenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(view: V, loadingView: LoadingView, errorView: ErrorView) {
        self.view = view
        self.loadingView = loadingView
        self.errorView = errorView
    }

    public static var title: String {
        return NSLocalizedString("VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedLocalizedString.self),
                                 comment: "Title for the feed view")
    }

    public func didStartLoadingView() {
        errorView.display(.noError)
        loadingView.display(LoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingView(with content: Content) {
        view.display(ViewModel(content: content))
        loadingView.display(LoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingView(with error: Error) {
        errorView.display(.error(message: loadError))
        loadingView.display(LoadingViewModel(isLoading: false))
    }
}
