//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeed
import UIKit

public final class ImageCommentCellController: NSObject, UITableViewDataSource {
    public var id: UUID {
        viewModel.id
    }

    private var cell: ImageCommentCell?
    private let viewModel: ImageCommentViewModel

    public init(viewModel: ImageCommentViewModel) {
        self.viewModel = viewModel
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.usernameLabel.text = viewModel.username
        cell?.createdAtLabel.text = viewModel.createdAt
        cell?.messageLabel.text = viewModel.message
        return cell!
    }
}

extension ImageCommentCellController: ImageCommentView {
    public func display(_ viewModel: ImageCommentViewModel) {
        cell?.usernameLabel.text = viewModel.username
        cell?.createdAtLabel.text = viewModel.createdAt
        cell?.messageLabel.text = viewModel.message
    }
}
