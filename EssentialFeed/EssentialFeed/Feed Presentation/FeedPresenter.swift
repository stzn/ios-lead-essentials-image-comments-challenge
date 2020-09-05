//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

public final class FeedPresenter {
	public static var title: String {
		return NSLocalizedString("FEED_VIEW_TITLE",
			tableName: "Feed",
			bundle: Bundle(for: FeedPresenter.self),
			comment: "Title for the feed view")
	}
}

extension Presenter where V.ViewModel == FeedViewModel {
    public func didFinishLoading(with feed: [FeedImage]) {
        self.didFinishLoading(with: .init(feed: feed))
    }
}
