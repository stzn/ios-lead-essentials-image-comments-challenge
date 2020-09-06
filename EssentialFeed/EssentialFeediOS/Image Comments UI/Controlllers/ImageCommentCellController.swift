//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed

public protocol ImageCommentCellControllerDelegate {
    func didRequestImageComment()
}

public final class ImageCommentCellController: ImageCommentView {
    private var cell: ImageCommentCell?
    private let delegate: ImageCommentCellControllerDelegate
    
    public init(delegate: ImageCommentCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestImageComment()
        return cell!
    }
    
    public func display(_ viewModel: ImageCommentViewModel) {
        cell?.usernameLabel.text = viewModel.username
        cell?.messageLabel.text = viewModel.message
        cell?.createdAtLabel.text = viewModel.createdAt
    }
}
