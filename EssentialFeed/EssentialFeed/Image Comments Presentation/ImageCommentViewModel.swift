//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public struct ImageCommentViewModel {
    public let id: UUID
    public let username: String
    public let createdAt: String
    public let message: String

    public init(id: UUID, username: String, createdAt: String, message: String) {
        self.id = id
        self.username = username
        self.createdAt = createdAt
        self.message = message
    }
}
