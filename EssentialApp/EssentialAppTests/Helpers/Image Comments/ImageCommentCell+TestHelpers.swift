//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeediOS

extension ImageCommentCell {
    var messageText: String {
        return messageLabel.text ?? ""
    }

    var createdAtText: String {
        return createdAtLabel.text ?? ""
    }

    var usernameText: String {
        return usernameLabel.text ?? ""
    }
}
