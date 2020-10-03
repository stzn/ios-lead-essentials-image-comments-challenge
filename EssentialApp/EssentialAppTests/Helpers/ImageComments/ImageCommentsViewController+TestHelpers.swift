//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeediOS

extension ListViewController {
    func simulateUserInitiatedImageCommentsReload() {
        refreshControl?.simulatePullToRefresh()
    }

    @discardableResult
    func simulateImageCommentsImageViewVisible(at index: Int) -> ImageCommentCell? {
        return imageCommentsView(at: index) as? ImageCommentCell
    }

    @discardableResult
    func simulateImageCommentsImageViewNotVisible(at row: Int) -> ImageCommentCell? {
        let view = simulateImageCommentsImageViewVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)

        return view
    }

    func simulateImageCommentsImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }

    func simulateImageCommentsImageViewNotNearVisible(at row: Int) {
        simulateImageCommentsImageViewNearVisible(at: row)

        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }

    func numberOfRenderedImageCommentsViews() -> Int {
        tableView.numberOfSections == 0 ? 0 : tableView.numberOfRows(inSection: feedImagesSection)
    }

    func imageCommentsView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedImageCommentsViews() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    private var feedImagesSection: Int {
        return 0
    }
}
