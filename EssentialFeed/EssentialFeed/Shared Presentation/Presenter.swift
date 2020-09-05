//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public struct ViewModel {
    public let feed: [FeedImage]
}

public struct LoadingViewModel {
    public let isLoading: Bool
}

public struct ErrorViewModel {
    public let message: String?

    static var noError: ErrorViewModel {
        return ErrorViewModel(message: nil)
    }

    static func error(message: String) -> ErrorViewModel {
        return ErrorViewModel(message: message)
    }
}


public protocol View {
    func display(_ viewModel: ViewModel)
}

public protocol LoadingView {
    func display(_ viewModel: LoadingViewModel)
}

public protocol ErrorView {
    func display(_ viewModel: ErrorViewModel)
}

public final class Presenter {
    private let view: View
    private let loadingView: LoadingView
    private let errorView: ErrorView

    private var loadError: String {
        return NSLocalizedString("VIEW_CONNECTION_ERROR",
                tableName: "Presenter",
                bundle: Bundle(for: Presenter.self),
                comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(view: View, loadingView: LoadingView, errorView: ErrorView) {
        self.view = view
        self.loadingView = loadingView
        self.errorView = errorView
    }

    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(LoadingViewModel(isLoading: true))
    }

    public func didFinishLoading(with feed: [FeedImage]) {
        view.display(ViewModel(feed: feed))
        loadingView.display(LoadingViewModel(isLoading: false))
    }

    public func didFinishLoading(with error: Error) {
        errorView.display(.error(message: loadError))
        loadingView.display(LoadingViewModel(isLoading: false))
    }
}
