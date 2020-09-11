//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeed
import UIKit

public protocol ImageCommentCellControllerDelegate {
    func didRequestImageComment()
}

public final class ImageCommentCellController: ImageCommentView {
    private let delegate: ImageCommentCellControllerDelegate
    private var cell: ImageCommentCell?

    public init(delegate: ImageCommentCellControllerDelegate) {
        self.delegate = delegate
    }

    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestImageComment()
        return cell!
    }

    func preload() {
        delegate.didRequestImageComment()
    }

    func cancelLoad() {
        releaseCellForReuse()
    }

    public func display(_ viewModel: ImageCommentViewModel) {
        cell?.usernameLabel.text = viewModel.username
        cell?.createdAtLabel.text = viewModel.createdAt
        cell?.messageLabel.text = viewModel.message
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}
