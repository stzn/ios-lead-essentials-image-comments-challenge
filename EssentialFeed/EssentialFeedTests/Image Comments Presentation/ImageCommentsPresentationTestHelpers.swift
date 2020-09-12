//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeed
import Foundation

var uniqueComment: ImageComment {
  return ImageComment(
    id: UUID(), message: "any message", createdAt: Date(), username: "any username")
}
