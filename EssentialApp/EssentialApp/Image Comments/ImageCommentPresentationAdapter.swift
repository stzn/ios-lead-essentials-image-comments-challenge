//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOS

final class ImageCommentPresentationAdapter<View: ImageCommentView>: ImageCommentCellControllerDelegate {
    private let model: ImageComment
    var presenter: ImageCommentPresenter<View>?
    
    init(model: ImageComment) {
        self.model = model
    }
    
    func didRequestImageComment() {
        presenter?.didFinishLoadingComment(with: model)
    }
}
