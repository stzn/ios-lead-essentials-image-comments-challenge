//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

public final class FeedPresenter {
    public static let stringsFileName = "Feed"
    public static let titleKey = "VIEW_TITLE"
    public static var title: String {
        return NSLocalizedString(
            titleKey,
            tableName: stringsFileName,
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the feed view")
    }
}

extension Presenter where V.ViewModel == FeedViewModel {
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        self.didFinishLoading(with: .init(feed: feed))
    }
}
