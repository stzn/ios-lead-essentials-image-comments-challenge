//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel

    func display(_ viewModel: ResourceViewModel)
}

public protocol LoadingView {
    func display(_ viewModel: LoadingViewModel)
}

public protocol ErrorView {
    func display(_ viewModel: ErrorViewModel)
}

public final class Presenter<Resource, View: ResourceView> {
    private let view: View
    private let loadingView: LoadingView
    private let errorView: ErrorView
    private let mapper: (Resource) throws -> View.ResourceViewModel

    private var loadError: String {
        return NSLocalizedString("VIEW_CONNECTION_ERROR",
                                 tableName: "Shared",
                                 bundle: Bundle(for: Presenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(view: View, loadingView: LoadingView, errorView: ErrorView,
                mapper: @escaping (Resource) throws -> View.ResourceViewModel) {
        self.view = view
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }

    public func didStartLoadingView() {
        errorView.display(.noError)
        loadingView.display(LoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingView(with resource: Resource) {
        do {
            view.display(try mapper(resource))
            loadingView.display(LoadingViewModel(isLoading: false))
        } catch {
            didFinishLoadingView(with: error)
        }
    }

    public func didFinishLoadingView(with error: Error) {
        errorView.display(.error(message: loadError))
        loadingView.display(LoadingViewModel(isLoading: false))
    }
}
