//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public protocol ViewPresenter {
    associatedtype ViewModel
    func display(_ viewModel: ViewModel)
}

public protocol LoadingViewPresenter {
    func display(_ viewModel: LoadingViewModel)
}

public protocol ErrorViewPresenter {
    func display(_ viewModel: ErrorViewModel)
}

public final class Presenter<V: ViewPresenter> {
    private let view: V
    private let loadingView: LoadingViewPresenter
    private let errorView: ErrorViewPresenter

    private var loadError: String {
        return NSLocalizedString("VIEW_CONNECTION_ERROR",
                tableName: "Presenter",
                bundle: Bundle(for: Presenter.self),
                comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(view: V, loadingView: LoadingViewPresenter, errorView: ErrorViewPresenter) {
        self.view = view
        self.loadingView = loadingView
        self.errorView = errorView
    }

    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(LoadingViewModel(isLoading: true))
    }

    public func didFinishLoading(with viewModel: V.ViewModel) {
        view.display(viewModel)
        loadingView.display(LoadingViewModel(isLoading: false))
    }

    public func didFinishLoading(with error: Error) {
        errorView.display(.error(message: loadError))
        loadingView.display(LoadingViewModel(isLoading: false))
    }
}

extension Presenter where V.ViewModel == FeedViewModel {
    public func didFinishLoading(with feed: [FeedImage]) {
        self.didFinishLoading(with: .init(feed: feed))
    }
}
