//	
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import UIKit
import EssentialApp
import EssentialFeed
import EssentialFeediOS

final class ImageCommentsUIIntegrationTests: XCTestCase {

    func test_feedView_hasTitle() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, localized(ImageCommentsPresenter.titleKey))
    }

    func test_loadImageCommentsActions_requestImageCommentsFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadImageCommentsCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadImageCommentsCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedImageCommentsReload()
        XCTAssertEqual(loader.loadImageCommentsCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedImageCommentsReload()
        XCTAssertEqual(loader.loadImageCommentsCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }

    func test_loadingImageCommentsIndicator_isVisibleWhileLoadingImageComments() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeImageCommentsLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")

        sut.simulateUserInitiatedImageCommentsReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        loader.completeImageCommentsLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }

    func test_loadImageCommentsCompletion_rendersSuccessfullyLoadedFeed() {
        let image0 = makeImageComment(message: "a message", username: "a username")
        let image1 = makeImageComment(message: "another message", username: "another username")
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeImageCommentsLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])

        sut.simulateUserInitiatedImageCommentsReload()
        loader.completeImageCommentsLoading(with: [image0, image1], at: 1)
        assertThat(sut, isRendering: [image0, image1])
    }

    func test_loadImageCommentsCompletion_rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyImageComments() {
        let image0 = makeImageComment()
        let image1 = makeImageComment()
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeImageCommentsLoading(with: [image0, image1], at: 0)
        assertThat(sut, isRendering: [image0, image1])

        sut.simulateUserInitiatedImageCommentsReload()
        loader.completeImageCommentsLoading(with: [], at: 1)
        assertThat(sut, isRendering: [])
    }

    func test_loadImageCommentsCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let image0 = makeImageComment()
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeImageCommentsLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])

        sut.simulateUserInitiatedImageCommentsReload()
        loader.completeImageCommentsLoadingWithError(at: 1)
        assertThat(sut, isRendering: [image0])
    }

    func test_loadImageCommentsCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeImageCommentsLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage,
                       sharedLocalized(SharedLocalizationInfo.connectionErrorKey))

        sut.simulateUserInitiatedImageCommentsReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }


    func test_loadImageCommentsCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageCommentsLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ImageCommentsViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = ImageCommentsUIComposer.imageCommnetsComposedWith(imageCommentsLoader: loader.loadPublisher)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    private func makeImageComment(message: String = "any", createdAt: Date = Date(), username: String = "any") -> ImageComment {
        return ImageComment(id: UUID(), message: message, createdAt: createdAt, username: username)
    }
}
