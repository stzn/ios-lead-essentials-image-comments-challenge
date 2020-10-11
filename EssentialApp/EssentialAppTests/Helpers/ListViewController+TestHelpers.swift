//
//  ListViewController+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Shinzan Takata on 2020/10/11.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeediOS

extension ListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        tableView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }

    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }

    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections == 0 ? 0 : tableView.numberOfRows(inSection: section)
    }

    func cell(at row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: imageCommentsSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    func simulateErrorViewTap() {
        errorView.simulateTap()
    }

    var errorMessage: String? {
        return errorView.message
    }

    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
}

// MARK: - FeedViewController

extension ListViewController {
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index)
    }

    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)

        return view
    }

    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }

    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)

        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }

    func simulateFeedImageViewDidSelectRow(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }

    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewVisible(at: index)?.renderedImage
    }

    func numberOfRenderedFeedImageViews() -> Int {
        numberOfRows(in: feedImagesSection)
    }

    func feedImageView(at row: Int) -> FeedImageCell? {
        return cell(at: row, section: feedImagesSection) as? FeedImageCell
    }

    private var feedImagesSection: Int {
        return 0
    }
}

// MARK: - ImageCommentsViewController

extension ListViewController {
    @discardableResult
    func simulateImageCommentsImageViewVisible(at index: Int) -> ImageCommentCell? {
        return imageCommentsView(at: index)
    }

    @discardableResult
    func simulateImageCommentsImageViewNotVisible(at row: Int) -> ImageCommentCell? {
        let view = simulateImageCommentsImageViewVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: imageCommentsSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)

        return view
    }

    func simulateImageCommentsImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: imageCommentsSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }

    func simulateImageCommentsImageViewNotNearVisible(at row: Int) {
        simulateImageCommentsImageViewNearVisible(at: row)

        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: imageCommentsSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }

    func numberOfRenderedImageCommentsViews() -> Int {
        numberOfRows(in: imageCommentsSection)
    }

    func imageCommentsView(at row: Int) -> ImageCommentCell? {
        return cell(at: row, section: imageCommentsSection) as? ImageCommentCell
    }

    func commentMessage(at row: Int) -> String? {
        let cell = imageCommentsView(at: row)!
        return cell.messageLabel?.text
    }

    private var imageCommentsSection: Int {
        return 0
    }
}
