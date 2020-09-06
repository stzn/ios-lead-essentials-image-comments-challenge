//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed

public protocol ImageCommentsViewControllerDelegate {
    func didRequestImageCommentsRefresh(for feed: FeedImage)
}

public final class ImageCommentsViewController: UITableViewController, LoadingViewPresenter, ErrorViewPresenter {
    @IBOutlet private(set) public var errorView: ErrorView?

    private var loadingControllers = [IndexPath: ImageCommentCellController]()

    private var tableModel = [ImageCommentCellController]() {
        didSet { tableView.reloadData() }
    }

    private let delegate: ImageCommentsViewControllerDelegate
    private let feed: FeedImage

    public init?(coder: NSCoder, feed: FeedImage, title: String,
                 delegate: ImageCommentsViewControllerDelegate) {
        self.feed = feed
        self.delegate = delegate
        super.init(coder: coder)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }

    @IBAction private func refresh() {
        delegate.didRequestImageCommentsRefresh(for: feed)
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
