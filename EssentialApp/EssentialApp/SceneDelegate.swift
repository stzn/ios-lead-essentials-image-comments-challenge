//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit
import CoreData
import Combine
import EssentialFeed

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let baseURL: URL = URL(string: "http://image-comments-challenge.essentialdeveloper.com")!
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("feed-store.sqlite"))
    }()

    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()

    private lazy var feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: makeLocalImageLoaderWithRemoteFallback,
            selection: showImageComments)

    private lazy var navigationController = UINavigationController(
        rootViewController: feedViewController)

    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func showImageComments(for model: FeedImage) {
        let commentsViewController = ImageCommentsUIComposer.imageCommnetsComposedWith(
            imageCommentsLoader: { self.makeRemoteImageCommentsLoader(model.id) } )

        feedViewController.navigationItem.backBarButtonItem
            = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController.pushViewController(commentsViewController, animated: true)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }

    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<[FeedImage], Swift.Error> {
        let remoteURL = FeedEndpoint.get.url(baseURL: baseURL)

        return httpClient
            .getPublisher(from: remoteURL)
            .tryMap(FeedImagesMapper.map)
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }

    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> AnyPublisher<Data, Swift.Error> {
        let localImageLoader = LocalFeedImageDataLoader(store: store)

        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [self] in
                self.httpClient
                    .getPublisher(from: url)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
            })
    }

    private func makeRemoteImageCommentsLoader(_ feedId: UUID) -> AnyPublisher<[ImageComment], Swift.Error> {
        let remoteURL = ImageCommentsEndpoint.get(feedId).url(baseURL: baseURL)
        return httpClient
            .getPublisher(from: remoteURL)
            .tryMap(ImageCommentsMapper.map)
            .eraseToAnyPublisher()
    }
}
