//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeediOS

extension ImageCommentsViewController {
    func simulateUserInitiatedImageCommentsReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateImageCommentViewVisible(at index: Int) -> ImageCommentCell? {
        return imageCommentView(at: index) as? ImageCommentCell
    }
    
    @discardableResult
    func simulateImageCommentViewNotVisible(at row: Int) -> ImageCommentCell? {
        let view = simulateImageCommentViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: imageCommentsSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        
        return view
    }
    
    var errorMessage: String? {
        return errorView?.message
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func numberOfRenderedImageCommentViews() -> Int {
        return tableView.numberOfRows(inSection: imageCommentsSection)
    }
    
    func imageCommentView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedImageCommentViews() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: imageCommentsSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var imageCommentsSection: Int {
        return 0
    }
}
