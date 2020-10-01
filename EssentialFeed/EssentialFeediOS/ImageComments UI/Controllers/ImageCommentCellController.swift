//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import EssentialFeed
import UIKit

public final class ImageCommentCellController: ImageCommentView, CellController {
    public var id: UUID {
        viewModel.id
    }

    private var cell: ImageCommentCell?
    private let viewModel: ImageCommentViewModel

    public init(viewModel: ImageCommentViewModel) {
        self.viewModel = viewModel
    }

    public func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        display(viewModel)
        return cell!
    }

    public func cancelLoad() {
        releaseCellForReuse()
    }

    public func preload() {}

    public func display(_ viewModel: ImageCommentViewModel) {
        cell?.usernameLabel.text = viewModel.username
        cell?.createdAtLabel.text = viewModel.createdAt
        cell?.messageLabel.text = viewModel.message
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}
