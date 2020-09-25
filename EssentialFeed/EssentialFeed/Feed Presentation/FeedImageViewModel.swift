//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

public struct FeedImageViewModel {
    public let id: UUID
    public let description: String?
    public let location: String?
    public var hasLocation: Bool {
        return location != nil
    }
}
