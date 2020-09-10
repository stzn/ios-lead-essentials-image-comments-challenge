//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

public final class FeedLocalizedString {
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: Self.self),
            comment: "Title for the feed view")
    }
}
