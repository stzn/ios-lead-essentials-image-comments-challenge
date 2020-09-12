//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentsLocalizedString {
  public static var title: String {
    return NSLocalizedString(
      "VIEW_TITLE",
      tableName: "ImageComments",
      bundle: Bundle(for: Self.self),
      comment: "Title for the feed view")
  }
}
