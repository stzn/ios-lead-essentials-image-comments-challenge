//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public struct ImageCommentViewModel {
    public let id: UUID
    public let message: String
    public let createdAt: String
    public let username: String

    public init(id: UUID, message: String, createdAt: String, username: String) {
        self.id = id
        self.message = message
        self.createdAt = createdAt
        self.username = username
    }
}
