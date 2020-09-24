//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

public final class FeedLocalizedString {
    public static var title: String {
        return NSLocalizedString("VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: Self.self),
                                 comment: "Title for the feed view")
    }

    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }

}
