//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class ImageCommentsSnapshotTests: XCTestCase {
	func test_imageCommentsWithContent() {
		let sut = makeSUT()

		sut.display(cellControllers())

		assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "IMAGE_COMMENTS_WITH_CONTENT_light")
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "IMAGE_COMMENTS_WITH_CONTENT_dark")
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraExtraLarge)), named: "IMAGE_COMMENTS_WITH_CONTENT_light_extraExtraExtraLarge")
	}

	// MARK: - Helpers

	private func makeSUT() -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let controller = storyboard.instantiateInitialViewController() as! ListViewController
		controller.loadViewIfNeeded()
		controller.tableView.showsVerticalScrollIndicator = false
		controller.tableView.showsHorizontalScrollIndicator = false
		return controller
	}

	private func cellControllers() -> [CellController] {
		commentCellControllers().map { CellController(id: UUID(), $0) }
	}

	private func commentCellControllers() -> [ImageCommentCellController] {
		return [
			ImageCommentCellController(
				viewModel: ImageCommentViewModel(message: String(repeating: "message1", count: 100),
				                                 createdAt: "10 days ago",
				                                 username: String(repeating: "username1", count: 5))
			),
			ImageCommentCellController(
				viewModel: ImageCommentViewModel(message: "message2",
				                                 createdAt: "1000 days ago",
				                                 username: "username2")
			),
		]
	}
}

private extension ListViewController {
	func display(_ stubs: [CommentStub]) {
		let cells: [CellController] = stubs.map { stub in
			let cellController = ImageCommentCellController(viewModel: stub.viewModel)
			stub.controller = cellController
			return CellController(id: UUID(), cellController)
		}

		display(cells)
	}
}

private class CommentStub {
	let viewModel: ImageCommentViewModel
	weak var controller: ImageCommentCellController?

	init(message: String, createdAt: String, username: String) {
		self.viewModel = ImageCommentViewModel(message: message, createdAt: createdAt, username: username)
	}
}
