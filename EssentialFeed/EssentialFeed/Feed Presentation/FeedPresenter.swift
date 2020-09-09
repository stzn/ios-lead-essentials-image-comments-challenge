//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedView {
	func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
	private let feedView: FeedView
	private let loadingView: LoadingView
	private let errorView: ErrorView
	
	private var feedLoadError: String {
		return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
				tableName: "Feed",
				bundle: Bundle(for: FeedPresenter.self),
				comment: "Error message displayed when we can't load the image feed from the server")
	}
	
	public init(feedView: FeedView, loadingView: LoadingView, errorView: ErrorView) {
		self.feedView = feedView
		self.loadingView = loadingView
		self.errorView = errorView
	}
	
	public static var title: String {
		return NSLocalizedString("FEED_VIEW_TITLE",
			tableName: "Feed",
			bundle: Bundle(for: FeedPresenter.self),
			comment: "Title for the feed view")
	}
	
	public func didStartLoadingFeed() {
		errorView.display(.noError)
		loadingView.display(LoadingViewModel(isLoading: true))
	}
	
	public func didFinishLoadingFeed(with feed: [FeedImage]) {
		feedView.display(FeedViewModel(feed: feed))
		loadingView.display(LoadingViewModel(isLoading: false))
	}
	
	public func didFinishLoadingFeed(with error: Error) {
		errorView.display(.error(message: feedLoadError))
		loadingView.display(LoadingViewModel(isLoading: false))
	}
}
