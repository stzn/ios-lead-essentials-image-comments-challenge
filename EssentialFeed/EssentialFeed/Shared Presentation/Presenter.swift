//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public protocol View {
    associatedtype ViewModel
    func display(_ viewModel: ViewModel)
}

public protocol LoadingView {
    func display(_ viewModel: LoadingViewModel)
}

public protocol ErrorView {
    func display(_ viewModel: ErrorViewModel)
}

public final class Presenter<V: View> {
    public let title: String

    private let view: V
    private let loadingView: LoadingView
    private let errorView: ErrorView

    private var loadError: String {
        return NSLocalizedString("VIEW_CONNECTION_ERROR",
                tableName: "Presenter",
                bundle: Bundle(for: Presenter.self),
                comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(title: String, view: V, loadingView: LoadingView, errorView: ErrorView) {
        self.title = title
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
