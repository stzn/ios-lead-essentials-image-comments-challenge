//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed

public protocol ImageCommentsViewControllerDelegate {
    func didRequestImageCommentsRefresh()
}

public final class ImageCommentsViewController: UITableViewController, LoadingViewPresenter, ErrorViewPresenter {
    @IBOutlet private(set) public var errorView: ErrorView?

    private var loadingControllers = [IndexPath: ImageCommentCellController]()

    private var tableModel = [ImageCommentCellController]() {
        didSet { tableView.reloadData() }
    }

    public var delegate: ImageCommentsViewControllerDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }

    @IBAction private func refresh() {
        delegate?.didRequestImageCommentsRefresh()
    }

    public func display(_ cellControllers: [ImageCommentCellController]) {
        loadingControllers = [:]
        tableModel = cellControllers
    }

    public func display(_ viewModel: LoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }

    public func display(_ viewModel: ErrorViewModel) {
        errorView?.message = viewModel.message
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }

    private func cellController(forRowAt indexPath: IndexPath) -> ImageCommentCellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }
}
